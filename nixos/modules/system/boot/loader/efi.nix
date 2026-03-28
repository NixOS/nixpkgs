{ config, lib, pkgs, ... }:
let
  cfg = config.boot.loader.efi;
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
        and `65535` may wait indefinitely. This behavior is implementation-specific.

        Set to `null` (the default) to leave the firmware timeout unmanaged.
        Requires {option}`boot.loader.efi.canTouchEfiVariables` to be `true`.
      '';
    };
  };

  config = lib.mkIf (cfg.firmwareTimeout != null) {
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
        efivar="/sys/firmware/efi/efivars/Timeout-8be4df61-93ca-11d2-aa0d-00e098032b8c"
        if [ "$NIXOS_ACTION" != "test" ]; then
          if [ ! -f "$efivar" ]; then
            echo "EFI Timeout variable not found, firmware may not support it; skipping"
          else
            desired=${toString cfg.firmwareTimeout}
            # EFI variable file: 4 bytes attributes + 2 bytes uint16 LE value
            current=$(${pkgs.coreutils}/bin/od -An -t u2 -j 4 -N 2 "$efivar" | ${pkgs.coreutils}/bin/tr -d ' ')
            if [ "$current" != "$desired" ]; then
              echo "setting EFI firmware timeout to ''${desired}s (was: ''${current}s)"
              lo=$(printf '%02x' $((desired & 0xFF)))
              hi=$(printf '%02x' $(((desired >> 8) & 0xFF)))
              # efivarfs marks files immutable to prevent accidental rm; clear it for write
              ${pkgs.e2fsprogs}/bin/chattr -i "$efivar"
              # Write: attributes (NV|BS|RT = 0x07) + uint16 LE timeout value
              printf "\x07\x00\x00\x00\x''${lo}\x''${hi}" > "$efivar"
            fi
          fi
        fi
      '';
    };
  };
}
