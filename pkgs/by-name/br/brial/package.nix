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
  version = "1.2.15";
  pname = "brial";

  src = fetchFromGitHub {
    owner = "BRiAl";
    repo = "BRiAl";
    tag = version;
    sha256 = "sha256-I8p2jdc2/oq9piy1QvNl+N0+MHDE5Xv1kawkRTjrWSU=";
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

  meta = with lib; {
    homepage = "https://github.com/BRiAl/BRiAl";
    description = "Legacy version of PolyBoRi maintained by sagemath developers";
    license = licenses.gpl2Plus;
    teams = [ teams.sage ];
    platforms = platforms.unix;
  };
}
