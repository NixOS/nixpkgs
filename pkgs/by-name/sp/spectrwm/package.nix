{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  pkg-config,
  libXrandr,
  libXcursor,
  libXft,
  libXt,
  xcbutil,
  xcbutilkeysyms,
  xcbutilwm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectrwm";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "conformal";
    repo = "spectrwm";
    tag = "SPECTRWM_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-Dnn/iIrceiAVuMR8iMGcc7LqNhWC496eT5gNrYOInRU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libXrandr
    libXcursor
    libXft
    libXt
    xcbutil
    xcbutilkeysyms
    xcbutilwm
    libbsd
  ];

  sourceRoot = finalAttrs.src.name + (if stdenv.hostPlatform.isDarwin then "/osx" else "/linux");

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Tiling window manager";
    homepage = "https://github.com/conformal/spectrwm";
    maintainers = with lib.maintainers; [
      rake5k
    ];
    license = lib.licenses.isc;
    platforms = lib.platforms.all;

    longDescription = ''
      spectrwm is a small dynamic tiling window manager for X11. It
      tries to stay out of the way so that valuable screen real estate
      can be used for much more important stuff. It has sane defaults
      and does not require one to learn a language to do any
      configuration. It was written by hackers for hackers and it
      strives to be small, compact and fast.
    '';
  };

})
