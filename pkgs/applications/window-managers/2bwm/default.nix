{
  lib,
  stdenv,
  fetchFromGitHub,
  config,
  libxcb,
  libxcb-keysyms,
  libxcb-wm,
  libx11,
  libxcb-util,
  xcbutilxrm,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.3";
  pname = "2bwm";

  src = fetchFromGitHub {
    owner = "venam";
    repo = "2bwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p1GnSQbNNQ+eeriXQ8r1l7aEJpM2FurTy2RDJYJZkfc=";
  };

  # Allow users to set their own list of patches
  patches = config."2bwm".patches or [ ];

  strictDeps = true;
  __structuredAttrs = true;

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

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
})
