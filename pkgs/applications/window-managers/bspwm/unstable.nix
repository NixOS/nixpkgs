{ stdenv, fetchFromGitHub, libxcb, libXinerama, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation {
  name = "bspwm-unstable-2016-09-30";


  src = fetchFromGitHub {
    owner   = "baskerville";
    repo    = "bspwm";
    rev     = "8664c007e44de162c1597fd7e163635b274fb747";
    sha256  = "0clvpz32z38i8kr10hqlifa661szpfn93c63m2aq2h4dwmr44slz";
  };

  buildInputs = [ libxcb libXinerama xcbutil xcbutilkeysyms xcbutilwm ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = {
    description = "A tiling window manager based on binary space partitioning (git version)";
    homepage = "https://github.com/baskerville/bspwm";
    maintainers = [ stdenv.lib.maintainers.meisternu stdenv.lib.maintainers.epitrochoid ];
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
