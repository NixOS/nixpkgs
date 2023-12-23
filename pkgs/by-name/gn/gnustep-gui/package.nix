{ lib
, clangStdenv
, gnustep-make
, wrapGNUstepAppsHook
, fetchzip
, gnustep-base
}:

clangStdenv.mkDerivation (finalAttrs: {
  version = "0.30.0";
  pname = "gnustep-gui";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-24hL4TeIY6izlhQUcxKI0nXITysAPfRrncRqsDm2zNk=";
  };

  nativeBuildInputs = [ gnustep-make wrapGNUstepAppsHook ];
  buildInputs = [ gnustep-base ];

  patches = [
    ./fixup-all.patch
  ];

  meta = {
    changelog = "https://github.com/gnustep/libs-gui/releases/tag/gui-${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    description = "A GUI class library of GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = lib.platforms.linux;
  };
})
