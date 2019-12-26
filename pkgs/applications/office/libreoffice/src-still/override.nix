{ stdenv, ... }:
attrs:
{
  NIX_CFLAGS_COMPILE = stdenv.lib.lists.remove "-mno-fma" attrs.NIX_CFLAGS_COMPILE;
  configureFlags = stdenv.lib.lists.remove "--without-export-validation" attrs.configureFlags;
  meta = attrs.meta // { description = "Comprehensive, professional-quality productivity suite (Still/Stable release)"; };
}
