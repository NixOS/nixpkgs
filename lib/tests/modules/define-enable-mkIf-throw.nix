{ lib, ... }:
{
  config.enable = lib.mkIf (throw "oops") true;
}
