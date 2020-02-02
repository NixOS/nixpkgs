{ stdenv, ... }:
attrs:
{
  configureFlags = stdenv.lib.lists.remove "--without-export-validation" attrs.configureFlags;
  meta = attrs.meta // { description = "Comprehensive, professional-quality productivity suite (Still/Stable release)"; };
}
