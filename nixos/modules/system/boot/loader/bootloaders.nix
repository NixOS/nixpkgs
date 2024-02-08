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

  config = {
    assertions = [
      {
        assertion = builtins.length (builtins.attrValues enabledBootloaders) > 0;
        message = ''A NixOS system require a bootloader setup to be built.
          Consider enabling the direct bootloader if you are booted via external means, e.g. QEMU, containers.
          Or, use one of the standard available bootloader.
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
