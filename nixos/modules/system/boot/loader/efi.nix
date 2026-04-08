{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.loader.efi;
  efibootmgr = "${pkgs.efibootmgr}/bin/efibootmgr";
  bootOrderFile = pkgs.writeText "efi-boot-order" (lib.concatStringsSep "\n" cfg.bootOrder);
in
{
  options.boot.loader.efi = {

    canTouchEfiVariables = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether the installation process is allowed to modify EFI boot variables.";
    };

    efiSysMountPoint = lib.mkOption {
      default = "/boot";
      type = lib.types.str;
      description = "Where the EFI System Partition is mounted.";
    };

    firmwareTimeout = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.ints.u16;
      description = ''
        Timeout (in seconds) for the UEFI firmware boot menu (e.g. EDK2).
        This sets the EFI `Timeout` variable, which controls how
        long the firmware waits at its own boot device selection menu before
        booting the default entry.

        This is distinct from {option}`boot.loader.timeout`, which controls the
        OS bootloader menu timeout (e.g. systemd-boot, GRUB).

        Note: the values `0` and `65535` (`0xFFFF`) are sometimes treated
        specially by firmware implementations — `0` may skip the menu entirely,
        and `65535` may wait indefinitely. This behavior is implementation specific.

        Set to `null` (the default) to leave the firmware timeout unmanaged.
        Requires {option}`boot.loader.efi.canTouchEfiVariables` to be `true`.
      '';
    };

    bootOrder = lib.mkOption {
      default = null;
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      description = ''
        Ordered list of patterns to set as the firmware boot order.
        Each pattern is matched as a substring against EFI boot entry labels
        shown by {command}`efibootmgr`. If a pattern matches no entries, a
        warning is emitted and the pattern is skipped. If a pattern matches
        more than one entry, the activation script will fail.

        This allows using short, portable patterns like `"Samsung SSD"` or
        `"PXEv4"` instead of full labels that contain device-specific details
        such as serial numbers or MAC addresses.

        Boot entries not matched by any pattern will be removed from the boot
        order but not deleted from NVRAM. Set to `null` (the default) to leave
        the boot order unmanaged.

        Requires {option}`boot.loader.efi.canTouchEfiVariables` to be `true`.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.firmwareTimeout != null) {
      assertions = [
        {
          assertion = cfg.canTouchEfiVariables;
          message = "boot.loader.efi.firmwareTimeout requires boot.loader.efi.canTouchEfiVariables to be true.";
        }
      ];

      system.activationScripts.efi-firmware-timeout = {
        supportsDryActivation = false;
        deps = [ "specialfs" ];
        text = ''
          if [ "$NIXOS_ACTION" != "test" ]; then
            ${efibootmgr} -t "${toString cfg.firmwareTimeout}"
          fi
        '';
      };
    })

    (lib.mkIf (cfg.bootOrder != null) {
      assertions = [
        {
          assertion = cfg.canTouchEfiVariables;
          message = "boot.loader.efi.bootOrder requires boot.loader.efi.canTouchEfiVariables to be true.";
        }
      ];

      system.activationScripts.efi-boot-order = {
        supportsDryActivation = false;
        deps = [ "specialfs" ];
        text = ''
          if [ "$NIXOS_ACTION" != "test" ]; then
            # Parse efibootmgr output into parallel arrays
            boot_labels=()
            boot_nums=()
            while IFS= read -r line; do
              if [[ "$line" =~ ^Boot([0-9A-Fa-f]{4})\*?[[:space:]]+(.*) ]]; then
                boot_nums+=("''${BASH_REMATCH[1]}")
                boot_labels+=("''${BASH_REMATCH[2]}")
              fi
            done < <(${efibootmgr})

            order=""
            while IFS= read -r pattern; do
              matched_num=""
              match_count=0
              for i in "''${!boot_labels[@]}"; do
                if [[ "''${boot_labels[$i]}" == *"$pattern"* ]]; then
                  matched_num="''${boot_nums[$i]}"
                  (( match_count++ ))
                fi
              done

              if (( match_count == 0 )); then
                echo "efi-boot-order: warning: pattern '$pattern' matched no EFI boot entries, skipping" >&2
                continue
              fi
              if (( match_count > 1 )); then
                echo "efi-boot-order: pattern '$pattern' matched $match_count entries (must match exactly 1):" >&2
                for i in "''${!boot_labels[@]}"; do
                  if [[ "''${boot_labels[$i]}" == *"$pattern"* ]]; then
                    echo "efi-boot-order:   Boot''${boot_nums[$i]} ''${boot_labels[$i]}" >&2
                  fi
                done
                exit 1
              fi

              if [ -n "$order" ]; then order="$order,"; fi
              order="$order$matched_num"
            done < ${bootOrderFile}

            ${efibootmgr} --bootorder "$order"
          fi
        '';
      };
    })
  ];
}
