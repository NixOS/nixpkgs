{ lib, stdenv, fetchFromGitHub, pkg-config, xorg }:

stdenv.mkDerivation {
  pname = "spectrwm";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "conformal";
    repo = "spectrwm";
    rev = "SPECTRWM_3_4_1";
    sha256 = "0bf0d25yr0craksamczn2mdy6cjp27l88smihlw9bw4p6a2qhi41";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with xorg; [
    libXrandr
    libXcursor
    libXft
    libXt
    xcbutil
    xcbutilkeysyms
    xcbutilwm
  ];

  prePatch = let
    subdir = if stdenv.isDarwin then "osx" else "linux";
  in "cd ${subdir}";

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A tiling window manager";
    homepage    = "https://github.com/conformal/spectrwm";
    maintainers = with maintainers; [ christianharke ];
    license     = licenses.isc;
    platforms   = platforms.all;

    longDescription = ''
      spectrwm is a small dynamic tiling window manager for X11. It
      tries to stay out of the way so that valuable screen real estate
      can be used for much more important stuff. It has sane defaults
      and does not require one to learn a language to do any
      configuration. It was written by hackers for hackers and it
      strives to be small, compact and fast.
    '';
  };

}
