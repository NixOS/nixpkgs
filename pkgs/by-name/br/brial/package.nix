{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boost,
  m4ri,
  gd,
}:

stdenv.mkDerivation rec {
  version = "1.2.12";
  pname = "brial";

  src = fetchFromGitHub {
    owner = "BRiAl";
    repo = "BRiAl";
    rev = version;
    sha256 = "sha256-y6nlqRBJRWohGDAKe/F37qBP1SgtFHR1HD+erFJReOM=";
  };

  # FIXME package boost-test and enable checks
  doCheck = false;

  configureFlags = [
    "--with-boost-unit-test-framework=no"
  ];

  buildInputs = [
    boost
    m4ri
    gd
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    homepage = "https://github.com/BRiAl/BRiAl";
    description = "Legacy version of PolyBoRi maintained by sagemath developers";
    license = lib.licenses.gpl2Plus;
    maintainers = lib.teams.sage.members;
    platforms = lib.platforms.unix;
  };
}
