{
  lib,
  gobjcStdenv,
  fetchpatch,
  fetchzip,
  aspell,
  audiofile,
  binutils-unwrapped,
  cups,
  giflib,
  gmp,
  gnustep-make-gcc,
  gnutls,
  icu,
  libffi,
  libgcrypt,
  libiberty,
  libiconv,
  libjpeg,
  libpng,
  libtiff,
  libxml2,
  libxslt,
  pkg-config,
  portaudio,
  wrapGNUstepAppsHook,
  gnustep-base
}:

gobjcStdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-base-gcc";
  inherit (gnustep-base) version src outputs patches;

nativeBuildInputs = [
    pkg-config
    wrapGNUstepAppsHook
  ];

  propagatedNativeBuildInputs = [
    gnustep-make-gcc
  ];

  propagatedBuildInputs = [
    aspell
    audiofile
    binutils-unwrapped
    cups
    giflib
    gmp
    gnutls
    icu
    libffi
    libgcrypt
    libiberty
    libiconv
    libjpeg
    libpng
    libtiff
    libxml2
    libxslt
    portaudio
  ];

  meta = {
    changelog = "https://github.com/gnustep/libs-base/releases/tag/base-${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }";
    description = "Implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa";
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
