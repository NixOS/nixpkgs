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
  inherit (gnustep-base) version src outputs patches nativeBuildInputs;

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
    inherit (gnustep-base-meta) changelog homepage license platforms;
    description = "Implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa";
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
  };
})
