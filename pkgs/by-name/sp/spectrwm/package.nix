{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  pkg-config,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectrwm";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "conformal";
    repo = "spectrwm";
    rev = "SPECTRWM_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-Dnn/iIrceiAVuMR8iMGcc7LqNhWC496eT5gNrYOInRU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = (
    with xorg;
    [
      libXrandr
      libXcursor
      libXft
      libXt
      xcbutil
      xcbutilkeysyms
      xcbutilwm
    ]
    ++ [ libbsd ]
  );

  prePatch =
    let
      subdir = if stdenv.hostPlatform.isDarwin then "osx" else "linux";
    in
    "cd ${subdir}";

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Tiling window manager";
    homepage = "https://github.com/conformal/spectrwm";
    maintainers = with maintainers; [ rake5k ];
    license = licenses.isc;
    platforms = platforms.all;

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
