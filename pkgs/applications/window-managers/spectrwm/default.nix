{ stdenv, fetchFromGitHub, pkgconfig, xorg }:

stdenv.mkDerivation {
  pname = "spectrwm";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "conformal";
    repo = "spectrwm";
    rev = "SPECTRWM_3_3_0";
    sha256 = "139mswlr0z5dbp5migm98qqg84syq0py1qladp3226xy6q3bnn08";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with xorg; [
    libXrandr
    libXcursor
    libXft
    libXt
    xcbutil
    xcbutilkeysyms
    xcbutilwm
  ];

  sourceRoot = let
    subdir = if stdenv.isDarwin then "osx" else "linux";
  in "source/${subdir}";

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
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
