{ config, options, lib, pkgs, utils, ... }:
let
  inherit (lib) literalMD mkOption filterAttrs types mkIf;
  loaders = config.boot.loader;
  foldEnabledBootloaders = fn: start:
    lib.lists.foldl fn start
    (builtins.attrValues (filterAttrs (utils.enabledBootloader options.boot.loader) loaders));
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
