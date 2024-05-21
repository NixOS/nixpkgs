{
  lib,
  stdenv,
  fetchFromGitLab,
  testers,
  gitUpdater,
  autoconf,
  automake,
  libtool,
  pkg-config,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aribb24";
  version = "1.0.4";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "jeeb";
    repo = "aribb24";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hq3LnLACZfV+E76ZDEHGlN51fS6AqFnNReE3JlWcv9M=";
  };

  buildInputs = [
    libpng
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  preConfigure = "autoreconf --install";

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "A library for ARIB STD-B24, decoding JIS 8 bit characters and parsing MPEG-TS stream";
    homepage = "https://code.videolan.org/jeeb/aribb24/";
    license = licenses.lgpl3Plus;
    pkgConfigModules = [ "aribb24" ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ jopejoe1 ];
  };
})
