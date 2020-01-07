{ stdenv, ... }:
attrs: {
  env = attrs.env // {
    NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + stdenv.lib.optionalString stdenv.isx86_64 " -mno-fma";
  };
}
