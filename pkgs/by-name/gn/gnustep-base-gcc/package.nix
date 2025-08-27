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
  inherit (gnustep-base) version src outputs;

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

  patches = [
    ../gnustep-base/fixup-paths.patch
    # https://github.com/gnustep/libs-base/issues/212 / https://www.sogo.nu/bugs/view.php?id=5416#c15585
    (fetchpatch {
      url = "https://github.com/gnustep/libs-base/commit/bd5f2909e6edc8012a0a6e44ea1402dfbe1353a4.patch";
      revert = true;
      sha256 = "02awigkbhqa60hfhqfh2wjsa960y3q6557qck1k2l231piz2xasa";
    })
    # https://github.com/gnustep/libs-base/issues/294
    (fetchpatch {
      url = "https://github.com/gnustep/libs-base/commit/37913d006d96a6bdcb963f4ca4889888dcce6094.patch";
      sha256 = "PyOmzRIirSKG5SQY+UwD6moCidPb8PXCx3aFgfwxsXE=";
    })
    # https://github.com/gnustep/libs-base/pull/334
    (fetchpatch {
      url = "https://github.com/gnustep/libs-base/commit/b4feee311f2beaf499a5742967213f523de30f16.patch";
      excludes = [ "ChangeLog" ];
      hash = "sha256-r0qpxjpEM6y+F/gju6JhpDNxnFJNHFG/mt3NmC1hWrs=";
    })
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
