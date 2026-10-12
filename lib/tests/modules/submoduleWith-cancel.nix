{ config, lib, ... }:
let
  inherit (lib) types mkOption;
  inherit (types)
    attrsOf
    lazyAttrsOf
    submoduleWith
    listOf
    int
    ;

  widget = { ... }: {
    options.enable = mkOption { default = true; };
    options.extra = mkOption {
      type = listOf int;
      description = "just evidence for type merging";
    };
  };
in
{
  imports = [
    {
      options.typeMerged = mkOption {
        type = lazyAttrsOf (submoduleWith {
          modules = [ ];
          cancel = {
            enable = false;
            extra = [ 2 ];
          };
        });
      };
    }
  ];
  options = {
    widgets = mkOption {
      type = lazyAttrsOf (submoduleWith {
        modules = [ widget ];
        cancel = {
          enable = false;
        };
      });
    };
    typeMerged = mkOption {
      type = lazyAttrsOf (submoduleWith {
        modules = [ widget ];
        cancel = {
          enable = false;
          extra = [ 1 ];
        };
      });
    };
    unmitigated = mkOption {
      type = lazyAttrsOf (submoduleWith {
        modules = [ widget ];
      });
    };
    unused = mkOption {
      type = attrsOf (submoduleWith {
        modules = [ widget ];
        cancel = abort "must not use";
      });
    };
    result = mkOption { };
  };
  config = {
    widgets.default = { };
    widgets.disabled = {
      enable = false;
    };
    widgets.self-referential.enable = config.widgets.default.enable;
    widgets.cancelled = lib.mkIf false (abort "must not use");
    unmitigated.cancelled = lib.mkIf false (abort "must not use");
    unused.disappeared = lib.mkIf false (abort "must not use");
    typeMerged.it = lib.mkIf false (abort "must not use");
    result =
      assert config.widgets.default.enable;
      assert !config.widgets.disabled.enable;
      assert !config.widgets.cancelled.enable; # the main assertion
      assert config.widgets.self-referential.enable;
      assert config.unmitigated.cancelled.enable; # could warn/deprecate/error later
      assert config.unused == { };
      assert
        config.typeMerged.it.extra == [
          1
          2
        ];
      "ok";
  };
}
