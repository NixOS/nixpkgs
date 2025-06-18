{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.schroot;
  iniFmt = pkgs.formats.ini { };
in
{
  options = {
    programs.schroot = {
      enable = lib.mkEnableOption "schroot, a lightweight virtualisation tool";
      package = lib.mkPackageOption pkgs "schroot" { };

      settings = lib.mkOption {
        type = iniFmt.type;
        default = { };
        example = {
          "noble" = {
            type = "directory";
            description = "Ubuntu 24.04 Noble";
            directory = "/srv/chroot/noble";
            users = "my-user";
            root-users = "my-user";
            personality = "linux";
            preserve-environment = false;
            profile = "my-profile";
            shell = "/bin/bash";
          };
        };
        description = ''
          Schroot configuration settings.
          For more details, see {manpage}`schroot.conf(5)`.
        '';
      };

      profiles = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              copyfiles = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                example = [ "/etc/resolv.conf" ];
                description = "A list of files to copy into the chroot from the host system.";
              };
              fstab = lib.mkOption {
                type = lib.types.path;
                example = lib.literalExpression ''
                  pkgs.writeText "my-schroot-fstab" '''
                    /proc           /proc           none    rw,bind         0       0
                    /sys            /sys            none    rw,bind         0       0
                    /dev            /dev            none    rw,bind         0       0
                    /dev/pts        /dev/pts        none    rw,bind         0       0
                    /home           /home           none    rw,rbind        0       0
                    /tmp            /tmp            none    rw,bind         0       0
                    /dev/shm        /dev/shm        none    rw,bind         0       0
                    /nix            /nix            none    ro,bind         0       0
                    /run/current-system /run/current-system none rw,bind    0       0
                    /run/wrappers   /run/wrappers   none    rw,bind         0       0
                  '''
                '';
                description = ''
                  A file in the format described in {manpage}`fstab(5)`, used to mount filesystems inside the chroot.
                  The mount location is relative to the root of the chroot.
                '';
              };
              nssdatabases = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                example = [
                  "passwd"
                  "shadow"
                  "group"
                  "gshadow"
                  "services"
                  "protocols"
                  "networks"
                  "hosts"
                ];
                description = ''
                  System databases (as described in /etc/nsswitch.conf on GNU/Linux systems) to copy into the chroot from the host.
                '';
              };
            };
          }
        );
        default = { };
        description = "Custom configuration profiles for schroot.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      etc =
        {
          # schroot requires this directory to exist
          "schroot/chroot.d/.keep".text = "";

          "schroot/schroot.conf".source = iniFmt.generate "schroot.conf" cfg.settings;
        }
        // (lib.attrsets.concatMapAttrs (
          name:
          {
            copyfiles,
            fstab,
            nssdatabases,
          }:
          {
            "schroot/${name}/copyfiles".text = (lib.strings.concatStringsSep "\n" copyfiles) + "\n";
            "schroot/${name}/fstab".source = fstab;
            "schroot/${name}/nssdatabases".text = (lib.strings.concatStringsSep "\n" nssdatabases) + "\n";
          }
        ) cfg.profiles);
    };

    security.wrappers.schroot = {
      source = "${cfg.package}/bin/schroot";
      owner = "root";
      group = "root";
      setuid = true;
    };

    # Schroot requires these directories to exist
    systemd.tmpfiles.rules = [
      "d /var/lib/schroot/session - root root - -"
      "d /var/lib/schroot/unpack - root root - -"
      "d /var/lib/schroot/union - root root - -"
      "d /var/lib/schroot/union/overlay - root root - -"
      "d /var/lib/schroot/union/underlay - root root - -"
    ];
  };
}
