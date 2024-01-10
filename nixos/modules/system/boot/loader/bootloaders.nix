{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.boot.loader;
  foldEnabledBootloaders = fn: start:
    # Reverse order is a conscious choice to make it so that "last append" is first considered here.
    # by default.
    lib.lists.foldl fn start
      (map (moduleId: cfg.builders.${moduleId}) cfg.enabled);
in
{
  meta = {
    maintainers = with maintainers; [ raitobezarius ];
    doc = ./bootloaders.md;
  };

  # Interface
  options = {
    boot.loader.builders = mkOption {
      type = types.attrsOf (types.submodule ({ ... }: {
        options = {
          id = mkOption {
            type = types.str;
            description = lib.mdDoc "A string describing the bootloader name";
          };
          script = mkOption {
            type = types.package;
            description = lib.mdDoc "An executable script that ...";
          };
        };
      }));
      default = {};
      example = literalExpression ''{ systemd-boot = finalSystemBootBuilder; }'';
      internal = true;
      description = lib.mdDoc ''
        An attribute set of builder for any potential bootloader.
        This is set internally by each bootloader with their
        final system boot builder script.
      '';
    };
    boot.loader.enabled = mkOption {
      type = types.listOf (types.enum [ "systemd-boot" "grub" ]); # TODO: this will break the doc evaluation? (builtins.attrNames cfg.builders));
      default = [ ];
      example = [ "systemd-boot" ];
      description = lib.mdDoc ''
        This option allows you to specify multiple bootloaders in NixOS which
        will be installed in the reverse order.

        The bootloaders will NOT be loaded in the order specified.
      '';
    };
  };

  # Implementation
  config = {
    system.build = let
      composedInnerBuilderScript =
        foldEnabledBootloaders (script: builder: ''
            # Installation procedure for ${builder.id}
            ${builder.script} "$@"
        '') "";
    in
      {
      installBootLoader = pkgs.writeShellScriptBin "nixos-install-bootloader" composedInnerBuilderScript;
      boot.loader.id = foldEnabledBootloaders (builder: previousId: "${previousId}-${builder.id}") "";
    };
  };
}
