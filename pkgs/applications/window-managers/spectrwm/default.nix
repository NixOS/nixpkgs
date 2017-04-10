{ fetchurl
, coreutils
, libX11
, libXrandr
, libXcursor
, libXft
, libXt
, libxcb
, xcbutil
, xcb-util-cursor
, xcbutilkeysyms
, xcbutilwm
, stdenv
}:

stdenv.mkDerivation rec {
  name = "spectrwm-${version}";
  version = "2.7.2";

  src = fetchurl {
    url = "https://github.com/conformal/spectrwm/archive/SPECTRWM_2_7_2.tar.gz";
    sha256 = "1yssqnhxlfl1b60gziqp8c5pzs1lr8p6anrnp9ga1zfdql3b7993";
  };


  buildInputs = [
    libX11
    libxcb
    libXrandr
    libXcursor
    libXft
    libXt
    xcbutil
    xcb-util-cursor
    xcbutilkeysyms
    xcbutilwm
  ];

  sourceRoot = let
    subdir = if stdenv.isDarwin then "osx" else "linux";
  in "spectrwm-SPECTRWM_2_7_2/${subdir}";

  makeFlags="PREFIX=$(out)";
  installPhase = "PREFIX=$out make install";

  meta = with stdenv.lib; {
    description = "A tiling window manager";
    homepage    = "https://github.com/conformal/spectrwm";
    maintainers = with maintainers; [ jb55 ];
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
