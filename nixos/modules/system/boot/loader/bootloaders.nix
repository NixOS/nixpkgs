{ config, options, lib, pkgs, utils, ... }:
let
  inherit (lib) literalMD mkOption filterAttrs types mkIf;
  loaders = config.boot.loader;
  enabledBootloaders = filterAttrs (utils.enabledBootloader options.boot.loader) loaders;
  foldEnabledBootloaders = fn: start:
    lib.lists.foldl fn start
    (builtins.attrValues enabledBootloaders);
in
{
  meta = {
    maintainers = with lib.maintainers; [ raitobezarius ];
    doc = ./bootloaders.md;
  };

  options = {
    boot.enable = mkOption {
      type = types.bool;
      default = true;
      internal = true;
      description = lib.mdDoc ''
        A NixOS system usually needs a boot mechanism.

        In contexts of direct boot, be it via QEMU or containers, this is not required.
        This option is present for an escape hatch for advanced users.
      '';
    };
    boot.loaderId = mkOption {
      type = types.str;
      default = foldEnabledBootloaders (builder: previousId: "${previousId}.${builder.id}") "";
      defaultText = literalMD "period-separated list of enabled bootloaders";
      example = "systemd-boot.grub";
      description = lib.mdDoc ''
        Current bootloader identifier, this is the concatenation of
        all enabled bootloader IDs with . separating them.
      '';
    };
  };

  config = mkIf config.boot.enable {
    assertions = [
      {
        assertion = builtins.length (builtins.attrValues enabledBootloaders) > 0;
        message = ''
          A NixOS system requires an explicit boot method.

          If you are on a UEFI-based system, consider enabling `boot.loader.systemd-boot`.
          If you are on a BIOS-based system, consider enabling `boot.loader.grub`.

          If you are on an embedded system, you can look if you support extlinux configuration files
          and enable `boot.loader.generic-extlinux-compatible`. This is often provided by Das U-Boot.

          Otherwise, you may need a custom bootloader.

          If you are on a system that does not require boot assistance, i.e. you are direct booted via external means,
          consider using `boot.loader.enable` which will turn off this error.
        '';
      }
    ];

    system.build = let
      composedInnerBuilderScript =
        foldEnabledBootloaders (script: builder: ''
            # Installation procedure for ${builder.id}
            ${builder.installHook} "$@"
        '') "";
    in
    {
      boot.loader.id = config.boot.loader.loaderId;
      installBootLoader = pkgs.writeShellScriptBin "nixos-install-bootloader" composedInnerBuilderScript;
    };
  };
}
