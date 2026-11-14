{ lib, ... }:
{
  config.enable = lib.mkMerge [ (throw "oops") ];
}
