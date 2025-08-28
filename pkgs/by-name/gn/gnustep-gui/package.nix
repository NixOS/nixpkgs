{
  lib,
  clangStdenv,
  fetchzip,
  gnustep-base,
  wrapGNUstepAppsHook,
}:

clangStdenv.mkDerivation (finalAttrs: {
  version = "0.32.0";
  pname = "gnustep-gui";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-HEH80P51mnLRt4+d+gzpGCv4u6oOdf+x68CcvkR6G/o=";
  };

  nativeBuildInputs = [ wrapGNUstepAppsHook ];

  propagatedBuildInputs = [ gnustep-base ];

  patches = [
    ./fixup-all.patch
  ];

  meta = {
    changelog = "https://github.com/gnustep/libs-gui/releases/tag/gui-${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }";
    description = "GUI class library of GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
    platforms = lib.platforms.linux;
  };
})
