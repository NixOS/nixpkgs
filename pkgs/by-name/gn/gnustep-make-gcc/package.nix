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

  propagatedBuildInputs = [ which ];

  meta = {
    changelog = "https://github.com/gnustep/tools-make/releases/tag/make-${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }";
    description = "Build manager for GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
    platforms = lib.platforms.unix;
  };
})
