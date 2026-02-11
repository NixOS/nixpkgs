{
  lib,
  stdenv,
  fetchFromGitHub,
  patches,
  libxcb,
  libxcb-keysyms,
  libxcb-wm,
  libx11,
  libxcb-util,
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
    libxcb-keysyms
    libxcb-wm
    libx11
    libxcb-util
    xcbutilxrm
  ];

  installPhase = "make install DESTDIR=$out PREFIX=\"\"";

  meta = {
    homepage = "https://github.com/venam/2bwm";
    description = "Fast floating WM written over the XCB library and derived from mcwm";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.unix;
  };
}
