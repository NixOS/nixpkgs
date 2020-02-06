{ stdenv, ... }:
attrs: {
  NIX_CFLAGS_COMPILE = attrs.NIX_CFLAGS_COMPILE + stdenv.lib.optionalString stdenv.isx86_64 " -mno-fma";
}
