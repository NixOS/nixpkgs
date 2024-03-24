{ config, lib, ... }:
let example = {
      _type = "flake";
      sourceInfo = {};
      inputs = {};
      outputs = {};
      foo = lib.mkForce {}; # must be copied verbatim
      packages = throw "Validating the flake is not the responsibility of this type, and evaluating any significant part of it would be too costly.";
    };
in
{
  options.result = lib.mkOption {};
  config = {
    flake = example;
    result = config.flake // { packages = null; } == example // { packages = null; };
  };
}
