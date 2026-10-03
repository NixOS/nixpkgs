{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  boost,
  m4ri,
  gd,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "1.2.15";
  pname = "brial";

  src = fetchFromGitHub {
    owner = "BRiAl";
    repo = "BRiAl";
    tag = finalAttrs.version;
    hash = "sha256-I8p2jdc2/oq9piy1QvNl+N0+MHDE5Xv1kawkRTjrWSU=";
  };

  patches = [
    # https://github.com/BRiAl/BRiAl/pull/64
    (fetchpatch {
      url = "https://github.com/BRiAl/BRiAl/commit/df5b4fd300cdbdd4cda920a27fdc5257f3cfea26.patch";
      hash = "sha256-MwpXTmK+3hJB/J7V8iHPfgyrxc/s9LhHgkAZDq7wZb0=";
    })
  ];

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
})
