{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.pam.mount;

  oflRequired = cfg.logoutHup || cfg.logoutTerm || cfg.logoutKill;

  fake_ofl = pkgs.writeShellScriptBin "fake_ofl" ''
    SIGNAL=$1
    MNTPT=$2
    ${pkgs.lsof}/bin/lsof | ${pkgs.gnugrep}/bin/grep $MNTPT | ${pkgs.gawk}/bin/awk '{print $2}' | ${pkgs.findutils}/bin/xargs ${pkgs.util-linux}/bin/kill -$SIGNAL
  '';

  anyPamMount = lib.any (svc: svc.enable && svc.pamMount) (
    lib.attrValues config.security.pam.services
  );
in

{
  options = {

    security.pam.mount = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable PAM mount system to mount filesystems on user login.
        '';
      };

      extraVolumes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          List of volume definitions for pam_mount.
          For more information, visit <https://pam-mount.sourceforge.net/pam_mount.conf.5.html>.
        '';
      };

      additionalSearchPaths = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.bindfs ]";
        description = ''
          Additional programs to include in the search path of pam_mount.
          Useful for example if you want to use some FUSE filesystems like bindfs.
        '';
      };

      cryptMountOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = lib.literalExpression ''
          [ "allow_discard" ]
        '';
        description = ''
          Global mount options that apply to every crypt volume.
          You can define volume-specific options in the volume definitions.
        '';
      };

      fuseMountOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = lib.literalExpression ''
          [ "nodev" "nosuid" "force-user=%(USER)" "gid=%(USERGID)" "perms=0700" "chmod-deny" "chown-deny" "chgrp-deny" ]
        '';
        description = ''
          Global mount options that apply to every FUSE volume.
          You can define volume-specific options in the volume definitions.
        '';
      };

      debugLevel = lib.mkOption {
        type = lib.types.int;
        default = 0;
        example = 1;
        description = ''
          Sets the Debug-Level. 0 disables debugging, 1 enables pam_mount tracing,
          and 2 additionally enables tracing in mount.crypt. The default is 0.
          For more information, visit <https://pam-mount.sourceforge.net/pam_mount.conf.5.html>.
        '';
      };

      logoutWait = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Amount of microseconds to wait until killing remaining processes after
          final logout.
          For more information, visit <https://pam-mount.sourceforge.net/pam_mount.conf.5.html>.
        '';
      };

      logoutHup = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Kill remaining processes after logout by sending a SIGHUP.
        '';
      };

      logoutTerm = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Kill remaining processes after logout by sending a SIGTERM.
        '';
      };

      logoutKill = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Kill remaining processes after logout by sending a SIGKILL.
        '';
      };

      createMountPoints = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Create mountpoints for volumes if they do not exist.
        '';
      };

      removeCreatedMountPoints = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Remove mountpoints created by pam_mount after logout. This
          only affects mountpoints that have been created by pam_mount
          in the same session.
        '';
      };
    };

  };

  config = lib.mkIf (cfg.enable || anyPamMount) {

    environment.systemPackages = [ pkgs.pam_mount ];
    environment.etc."security/pam_mount.conf.xml" = {
      source =
        let
          extraUserVolumes = lib.filterAttrs (
            n: u: u.cryptHomeLuks != null || u.pamMount != { }
          ) config.users.users;
          mkAttr = k: v: ''${k}="${v}"'';
          userVolumeEntry =
            user:
            let
              attrs = {
                user = user.name;
                path = user.cryptHomeLuks;
                mountpoint = user.home;
              }
              // user.pamMount;
            in
            "<volume ${lib.concatStringsSep " " (lib.mapAttrsToList mkAttr attrs)} />\n";
        in
        pkgs.writeText "pam_mount.conf.xml" ''
          <?xml version="1.0" encoding="utf-8" ?>
          <!DOCTYPE pam_mount SYSTEM "pam_mount.conf.xml.dtd">
          <!-- auto generated from Nixos: modules/config/users-groups.nix -->
          <pam_mount>
          <debug enable="${toString cfg.debugLevel}" />
          <!-- if activated, requires ofl from hxtools to be present -->
          <logout wait="${toString cfg.logoutWait}" hup="${if cfg.logoutHup then "yes" else "no"}" term="${
            if cfg.logoutTerm then "yes" else "no"
          }" kill="${if cfg.logoutKill then "yes" else "no"}" />
          <!-- set PATH variable for pam_mount module -->
          <path>${lib.makeBinPath ([ pkgs.util-linux ] ++ cfg.additionalSearchPaths)}</path>
          <!-- create mount point if not present -->
          <mkmountpoint enable="${if cfg.createMountPoints then "1" else "0"}" remove="${
            if cfg.removeCreatedMountPoints then "true" else "false"
          }" />
          <!-- specify the binaries to be called -->
          <!-- the comma in front of the options is necessary for empty options -->
          <fusemount>${pkgs.fuse}/bin/mount.fuse %(VOLUME) %(MNTPT) -o ,${
            lib.concatStringsSep "," (cfg.fuseMountOptions ++ [ "%(OPTIONS)" ])
          }'</fusemount>
          <fuseumount>${pkgs.fuse}/bin/fusermount -u %(MNTPT)</fuseumount>
          <!-- the comma in front of the options is necessary for empty options -->
          <cryptmount>${pkgs.pam_mount}/bin/mount.crypt -o ,${
            lib.concatStringsSep "," (cfg.cryptMountOptions ++ [ "%(OPTIONS)" ])
          } %(VOLUME) %(MNTPT)</cryptmount>
          <cryptumount>${pkgs.pam_mount}/bin/umount.crypt %(MNTPT)</cryptumount>
          <pmvarrun>${pkgs.pam_mount}/bin/pmvarrun -u %(USER) -o %(OPERATION)</pmvarrun>
          ${lib.optionalString oflRequired "<ofl>${fake_ofl}/bin/fake_ofl %(SIGNAL) %(MNTPT)</ofl>"}
          ${lib.concatStrings (map userVolumeEntry (lib.attrValues extraUserVolumes))}
          ${lib.concatStringsSep "\n" cfg.extraVolumes}
          </pam_mount>
        '';
    };

  };
}
