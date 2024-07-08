{ config, lib, ... }:

{
  options = {
    result = lib.mkOption { };
    weird = lib.mkOption {
      type = lib.types.submoduleWith {
        # I generally recommend against overriding lib, because that leads to
        # slightly incompatible dialects of the module system.
        # Nonetheless, it's worth guarding the property that the module system
        # evaluates with a completely custom lib, as a matter of separation of
        # concerns.
        specialArgs.lib = { };
        modules = [ ];
      };
    };
  };
  config.weird = args@{ ... /* note the lack of a `lib` argument */ }:
  assert args.lib == { };
  assert args.specialArgs == { lib = { }; };
  {
    options.foo = lib.mkOption { };
    config.foo = lib.mkIf true "alright";
  };
  config.result =
    assert config.weird.foo == "alright";
    "ok";
}
