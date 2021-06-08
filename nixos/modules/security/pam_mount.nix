{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.pam.mount;

  anyPamMount = any (attrByPath ["pamMount"] false) (attrValues config.security.pam.services);
in

{
  options = {

    security.pam.mount = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable PAM mount system to mount fileystems on user login.
        '';
      };

      extraVolumes = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of volume definitions for pam_mount.
          For more information, visit <link
          xlink:href="http://pam-mount.sourceforge.net/pam_mount.conf.5.html" />.
        '';
      };

      additionalSearchPaths = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample "[ pkgs.bindfs ]";
        description = ''
          Additional programs to include in the search path of pam_mount.
          Useful for example if you want to use some FUSE filesystems like bindfs.
        '';
      };

      fuseMountOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExample ''
          [ "nodev" "nosuid" "force-user=%(USER)" "gid=%(USERGID)" "perms=0700" "chmod-deny" "chown-deny" "chgrp-deny" ]
        '';
        description = ''
          Global mount options that apply to every FUSE volume.
          You can define volume-specific options in the volume definitions.
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
          <debug enable="0" />

          <!-- if activated, requires ofl from hxtools to be present -->
          <logout wait="0" hup="no" term="no" kill="no" />
          <!-- set PATH variable for pam_mount module -->
          <path>${makeBinPath ([ pkgs.util-linux ] ++ cfg.additionalSearchPaths)}</path>
          <!-- create mount point if not present -->
          <mkmountpoint enable="1" remove="true" />

          <!-- specify the binaries to be called -->
          <fusemount>${pkgs.fuse}/bin/mount.fuse %(VOLUME) %(MNTPT) -o ${concatStringsSep "," (cfg.fuseMountOptions ++ [ "%(OPTIONS)" ])}</fusemount>
          <cryptmount>${pkgs.pam_mount}/bin/mount.crypt %(VOLUME) %(MNTPT)</cryptmount>
          <cryptumount>${pkgs.pam_mount}/bin/umount.crypt %(MNTPT)</cryptumount>
          <pmvarrun>${pkgs.pam_mount}/bin/pmvarrun -u %(USER) -o %(OPERATION)</pmvarrun>

          ${concatStrings (map userVolumeEntry (attrValues extraUserVolumes))}
          ${concatStringsSep "\n" cfg.extraVolumes}
          </pam_mount>
          '';
    };

  };
}
