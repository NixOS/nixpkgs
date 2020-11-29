{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.pam_mount;

  anyEnable = any (attrByPath [ "modules" "pam_mount" "enable" ] false) (attrValues pamCfg.services);

  moduleOptions = global: {
    enable = mkOption {
      type = types.bool;
      default = if global then false else cfg.enable;
      description = ''
        Enable PAM mount system to mount fileystems on user login.
      '';
    };

    extraVolumes = mkOption {
      type = types.listOf types.str;
      default = if global then [] else cfg.extraVolumes;
      description = ''
        List of volume definitions for pam_mount.
        For more information, visit <link
        xlink:href="http://pam-mount.sourceforge.net/pam_mount.conf.5.html" />.
      '';
    };
  };
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              # Extra volumes can only be defined globally
              modules.pam_mount = removeAttrs (moduleOptions false) [ "extraVolumes" ];
            };

            config = mkIf config.modules.pam_mount.enable {
              auth = mkDefault {
                pam_mount = {
                  control = "optional";
                  path = "${pkgs.pam_mount}/lib/security/pam_mount.so";
                  order = 23000;
                };
              };

              password = mkDefault {
                pam_mount = {
                  control = "optional";
                  path = "${pkgs.pam_mount}/lib/security/pam_mount.so";
                  order = 3000;
                };
              };

              session = mkDefault {
                pam_mount = {
                  control = "optional";
                  path = "${pkgs.pam_mount}/lib/security/pam_mount.so";
                  order = 6000;
                };
              };
            };
          })
        );
      };

      modules.pam_mount = moduleOptions true;
    };
  };

  config = mkIf (cfg.enable || anyEnable) {
    environment.systemPackages = [ pkgs.pam_mount ];
    environment.etc."security/pam_mount.conf.xml" = {
      source =
        let
          extraUserVolumes = filterAttrs (n: u: u.cryptHomeLuks != null) config.users.users;
          userVolumeEntry = user: "<volume user=\"${user.name}\" path=\"${user.cryptHomeLuks}\" mountpoint=\"${user.home}\" />\n";
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
          <path>${pkgs.utillinux}/bin</path>
          <!-- create mount point if not present -->
          <mkmountpoint enable="1" remove="true" />

          <!-- specify the binaries to be called -->
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
