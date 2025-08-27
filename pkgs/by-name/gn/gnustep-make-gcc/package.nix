{
  lib,
  gobjcStdenv,
  fetchurl,
  gnustep-libobjc,
  which,
  gnustep-make
}:

gobjcStdenv.mkDerivation (finalAttrs: {
  inherit (gnustep-make) version src configureFlags preConfigure makeFlags propagatedBuildInputs patches setupHook;
  pname = "gnustep-make-gcc";

  meta = {
    inherit (gnustep-make.meta) changelog homepage license platforms maintainers;
    description = "Build manager for GNUstep (GCC environment)";
  };
})
