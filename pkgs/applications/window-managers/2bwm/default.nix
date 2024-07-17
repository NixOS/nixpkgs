{
  lib,
  stdenv,
  fetchFromGitHub,
  patches,
  libxcb,
  xcbutilkeysyms,
  xcbutilwm,
  libX11,
  xcbutil,
  xcbutilxrm,
}:

stdenv.mkDerivation rec {
  version = "0.3";
  pname = "2bwm";

  src = fetchFromGitHub {
    owner = "venam";
    repo = "2bwm";
    rev = "v${version}";
    sha256 = "1xwib612ahv4rg9yl5injck89dlpyp5475xqgag0ydfd0r4sfld7";
  };

  # Allow users set their own list of patches
  inherit patches;

  buildInputs = [
    libxcb
    xcbutilkeysyms
    xcbutilwm
    libX11
    xcbutil
    xcbutilxrm
  ];

  installPhase = "make install DESTDIR=$out PREFIX=\"\"";

  meta = with lib; {
    homepage = "https://github.com/venam/2bwm";
    description = "A fast floating WM written over the XCB library and derived from mcwm";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}
