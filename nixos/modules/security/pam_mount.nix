{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.pam.mount;

  oflRequired = cfg.logoutHup || cfg.logoutTerm || cfg.logoutKill;

  fake_ofl = pkgs.writeShellScriptBin "fake_ofl" ''
    SIGNAL=$1
    MNTPT=$2
    ${pkgs.lsof}/bin/lsof | ${pkgs.gnugrep}/bin/grep $MNTPT | ${pkgs.gawk}/bin/awk '{print $2}' | ${pkgs.findutils}/bin/xargs ${pkgs.util-linux}/bin/kill -$SIGNAL
  '';

  anyPamMount = any (attrByPath ["pamMount"] false) (attrValues config.security.pam.services);
in

{
  options = {

    security.pam.mount = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable PAM mount system to mount fileystems on user login.
        '';
      };

      extraVolumes = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          List of volume definitions for pam_mount.
          For more information, visit <http://pam-mount.sourceforge.net/pam_mount.conf.5.html>.
        '';
      };

      additionalSearchPaths = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExpression "[ pkgs.bindfs ]";
        description = lib.mdDoc ''
          Additional programs to include in the search path of pam_mount.
          Useful for example if you want to use some FUSE filesystems like bindfs.
        '';
      };

      fuseMountOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExpression ''
          [ "nodev" "nosuid" "force-user=%(USER)" "gid=%(USERGID)" "perms=0700" "chmod-deny" "chown-deny" "chgrp-deny" ]
        '';
        description = lib.mdDoc ''
          Global mount options that apply to every FUSE volume.
          You can define volume-specific options in the volume definitions.
        '';
      };

      debugLevel = mkOption {
        type = types.int;
        default = 0;
        example = 1;
        description = lib.mdDoc ''
          Sets the Debug-Level. 0 disables debugging, 1 enables pam_mount tracing,
          and 2 additionally enables tracing in mount.crypt. The default is 0.
          For more information, visit <http://pam-mount.sourceforge.net/pam_mount.conf.5.html>.
        '';
      };

      logoutWait = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          Amount of microseconds to wait until killing remaining processes after
          final logout.
          For more information, visit <http://pam-mount.sourceforge.net/pam_mount.conf.5.html>.
        '';
      };

      logoutHup = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Kill remaining processes after logout by sending a SIGHUP.
        '';
      };

      logoutTerm = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Kill remaining processes after logout by sending a SIGTERM.
        '';
      };

      logoutKill = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Kill remaining processes after logout by sending a SIGKILL.
        '';
      };

      createMountPoints = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Create mountpoints for volumes if they do not exist.
        '';
      };

      removeCreatedMountPoints = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Remove mountpoints created by pam_mount after logout. This
          only affects mountpoints that have been created by pam_mount
          in the same session.
        '';
      };
    };

  };

  config = mkIf (cfg.enable || anyPamMount) {

    environment.systemPackages = [ pkgs.pam_mount ];
    environment.etc."security/pam_mount.conf.xml" = {
      source =
        let
          extraUserVolumes = filterAttrs (n: u: u.cryptHomeLuks != null || u.pamMount != {}) config.users.users;
          mkAttr = k: v: ''${k}="${v}"'';
          userVolumeEntry = user: let
            attrs = {
              user = user.name;
              path = user.cryptHomeLuks;
              mountpoint = user.home;
            } // user.pamMount;
          in
            "<volume ${concatStringsSep " " (mapAttrsToList mkAttr attrs)} />\n";
        in
         pkgs.writeText "pam_mount.conf.xml" ''
          <?xml version="1.0" encoding="utf-8" ?>
          <!DOCTYPE pam_mount SYSTEM "pam_mount.conf.xml.dtd">
          <!-- auto generated from Nixos: modules/config/users-groups.nix -->
          <pam_mount>
          <debug enable="${toString cfg.debugLevel}" />
          <!-- if activated, requires ofl from hxtools to be present -->
          <logout wait="${toString cfg.logoutWait}" hup="${if cfg.logoutHup then "yes" else "no"}" term="${if cfg.logoutTerm then "yes" else "no"}" kill="${if cfg.logoutKill then "yes" else "no"}" />
          <!-- set PATH variable for pam_mount module -->
          <path>${makeBinPath ([ pkgs.util-linux ] ++ cfg.additionalSearchPaths)}</path>
          <!-- create mount point if not present -->
          <mkmountpoint enable="${if cfg.createMountPoints then "1" else "0"}" remove="${if cfg.removeCreatedMountPoints then "true" else "false"}" />
          <!-- specify the binaries to be called -->
          <fusemount>${pkgs.fuse}/bin/mount.fuse %(VOLUME) %(MNTPT) -o ${concatStringsSep "," (cfg.fuseMountOptions ++ [ "%(OPTIONS)" ])}</fusemount>
          <fuseumount>${pkgs.fuse}/bin/fusermount -u %(MNTPT)</fuseumount>
          <cryptmount>${pkgs.pam_mount}/bin/mount.crypt %(VOLUME) %(MNTPT)</cryptmount>
          <cryptumount>${pkgs.pam_mount}/bin/umount.crypt %(MNTPT)</cryptumount>
          <pmvarrun>${pkgs.pam_mount}/bin/pmvarrun -u %(USER) -o %(OPERATION)</pmvarrun>
          ${optionalString oflRequired "<ofl>${fake_ofl}/bin/fake_ofl %(SIGNAL) %(MNTPT)</ofl>"}
          ${concatStrings (map userVolumeEntry (attrValues extraUserVolumes))}
          ${concatStringsSep "\n" cfg.extraVolumes}
          </pam_mount>
          '';
    };

  };
}
