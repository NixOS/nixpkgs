{ lib, options, ... }:

let
  superOptions = options;
  submod = { lib, config, ... }: {
    options = {
      super.enable = lib.mkSuperOptionAlias (superOptions.enable or null);
    };

    config = {
      # Note: This is different than `super.enable = config.enable;`.
      super.enable = lib.mkIf config.enable true;
    };
  };
in

{
  imports = [
    ./declare-enable.nix
    ./declare-attrsOfSub-any-enable.nix
  ];

  options = {
    attrsOfSub = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submoduleWith {
        modules = [ submod ];
        shorthandOnlyDefinesConfig = true;
        exportOptionsUnderConfig = true;
      });
    };
  };

  config = {
    enable = lib.mkForEachSubModule
      (eval: lib.mkAliasDefinitions eval.options.super.enable)
      options.attrsOfSub;
  };
}
