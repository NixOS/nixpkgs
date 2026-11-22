{ lib, ... }:

{
  options.a.b.c = lib.mkOption { type = lib.types.int; };
  config.a.b = lib.mkIf true true;
}
