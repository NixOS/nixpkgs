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
  version = "1.2.14";
  pname = "brial";

  src = fetchFromGitHub {
    owner = "BRiAl";
    repo = "BRiAl";
    rev = version;
    sha256 = "sha256-vefvqlJab4lVHH35uItdNw5YBEOgVrETIYGoPlq8660=";
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
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
  };
}
