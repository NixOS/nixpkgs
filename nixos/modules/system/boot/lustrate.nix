{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.boot.initrd.systemd;
in

{
  options = {
    boot.initrd.systemd.lustrate.enable = lib.mkEnableOption "lustration" // {
      description = ''
        Whether to enable lustration in the systemd initrd. This is used for
        installation from another distribution. Please see [the manual] for
        more details.

        This option only has an effect if systemd initrd is enabled with the
        `boot.initrd.systemd.enable` option. If systemd initrd is disabled,
        lustration is always available.

        Warning: Lustration may interact unexpectedly with complex filesystem
        setups. Use with caution.

        [the manual]: https://nixos.org/manual/nixos/stable#sec-installing-from-other-distro
      '';
    };
  };

  config = lib.mkIf (cfg.enable && cfg.lustrate.enable) {
    boot.initrd.systemd.services.lustrate = {
      description = "Lustration of the root filesystem";

      unitConfig = {
        ConditionPathExists = [ "/sysroot/etc/NIXOS_LUSTRATE" ];

        # We need to lustrate after /sysroot is mounted, but before anything
        # else is mounted on top.
        Requires = [ "sysroot.mount" ];
        After = [
          "sysroot.mount"
          "systemd-repart.service"
        ];
        Before = [
          "initrd-root-fs.target"
          "systemd-volatile-root.service"
        ];
      };
      requiredBy = [ "initrd-root-fs.target" ];

      serviceConfig = {
        Type = "oneshot";
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };

      path = [ pkgs.coreutils ];
      script = ''
        # Duplicated from NixOS nixos/modules/system/boot/stage-1-init.sh for
        # maximum chance of being functionally compatible, and so that
        # stage-1-init.sh can be removed later.

        lustrateRoot () {
          local root="$1"

          echo
          echo -e "\e[1;33m<<< ${config.system.nixos.distroName} is now lustrating the root filesystem (cruft goes to /old-root) >>>\e[0m"
          echo

          mkdir -m 0755 -p "$root/old-root.tmp"

          echo
          echo "Moving impurities out of the way:"
          for d in "$root"/*
          do
              [ "$d" == "$root/nix"          ] && continue
              [ "$d" == "$root/boot"         ] && continue # Don't render the system unbootable
              [ "$d" == "$root/old-root.tmp" ] && continue

              mv -v "$d" "$root/old-root.tmp"
          done

          # Use .tmp to make sure subsequent invocations don't clash
          mv -v "$root/old-root.tmp" "$root/old-root"

          mkdir -m 0755 -p "$root/etc"
          touch "$root/etc/NIXOS"

          exec 4< "$root/old-root/etc/NIXOS_LUSTRATE"

          echo
          echo "Restoring selected impurities:"
          while read -u 4 keeper; do
              dirname="$(dirname "$keeper")"
              mkdir -m 0755 -p "$root/$dirname"
              cp -av "$root/old-root/$keeper" "$root/$keeper"
          done

          exec 4>&-
        }

        set -euo pipefail

        # Should be checked by systemd, but I find this convenient for testing
        [ -f "/sysroot/etc/NIXOS_LUSTRATE" ] || exit 0
        lustrateRoot /sysroot
      '';
    };
  };
}
