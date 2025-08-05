{
  lib,
  mkPerSystemOption,
  config,
  ...
}:
{
  imports = [
    (mkPerSystemOption {
      name = "checks";
      type = lib.types.lazyAttrsOf lib.types.package;
    })
  ];

  outputs = { inherit (config.perSystem.applied) checks; };
}
