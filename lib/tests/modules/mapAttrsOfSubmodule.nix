{
  lib,
  options,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (types)
    submodule
    attrsOf
    lazyAttrsOf
    attrsWith
    ;
  def = (lib.mkDefault null).priority;
  optdef = (lib.mkOptionDefault null).priority;

  enabledModule = {
    options.enable = mkOption { default = true; };
  };
in
{
  options.services = mkOption {
    type = attrsOf (submodule enabledModule);
  };
  options.files = mkOption {
    type = lazyAttrsOf (submodule enabledModule);
  };
  options.noDefs = mkOption {
    type = attrsWith { elemType = submodule enabledModule; };
  };
  options.result = mkOption { };
  config.services.empty = { };
  config.services.default.enable = lib.mkDefault false;
  config.files.empty = { };
  config.files.default.enable = lib.mkDefault false;
  config.files.quirk = lib.mkIf false { };
  config.result =
    assert
      lib.modules.mapAttrsOfSubmodule (name: { cfg, opt }: {
        inherit name cfg;
        prio = opt.enable.highestPrio;
      }) options.services == {
        empty = {
          name = "empty";
          cfg.enable = true;
          prio = optdef;
        };
        default = {
          name = "default";
          cfg.enable = false;
          prio = def;
        };
      };
    assert
      lib.modules.mapAttrsOfSubmodule (name: { cfg, opt }: {
        inherit name cfg;
        prio = opt.enable.highestPrio;
      }) options.files == {
        empty = {
          name = "empty";
          cfg.enable = true;
          prio = optdef;
        };
        default = {
          name = "default";
          cfg.enable = false;
          prio = def;
        };
        quirk = {
          name = "quirk";
          cfg.enable = true; # unmitigated flaw; could add emptyValue to attrsWith
          prio = optdef;
        };
      };
    assert lib.modules.mapAttrsOfSubmodule (abort "unused") options.noDefs == { };
    "ok";
}
