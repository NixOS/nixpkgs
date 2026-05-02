{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  expat,
  fmt,
  proj,
  bzip2,
  cli11,
  zlib,
  boost,
  libpq,
  python3,
  withLuaJIT ? false,
  lua,
  luajit,
  libosmium,
  nlohmann_json,
  opencv,
  potrace,
  protozero,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm2pgsql";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "osm2pgsql-dev";
    repo = "osm2pgsql";
    rev = finalAttrs.version;
    hash = "sha256-ZKSyMNc+EHY4QBTLtUiWiTMEcmAAbrV1xqxmvNF96f8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/osm2pgsql-dev/osm2pgsql/commit/6c96199194807283d4b3acbc214ea5d679791d1f.patch";
      name = "fix-fmt-localtime.patch";
      hash = "sha256-9GRyrMEHYMwU82TJ55zef2Dbz1yO51jT4oryOtyJd9A=";
    })
  ];

  postPatch = ''
    # Remove bundled libraries
    rm -r contrib
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    bzip2
    cli11
    expat
    fmt
    libosmium
    libpq
    nlohmann_json
    opencv
    potrace
    proj
    protozero
    (python3.withPackages (
      p: with p; [
        psycopg2
        pyosmium
      ]
    ))
    zlib
  ]
  ++ lib.optional withLuaJIT luajit
  ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    (lib.cmakeBool "EXTERNAL_LIBOSMIUM" true)
    (lib.cmakeBool "EXTERNAL_PROTOZERO" true)
    (lib.cmakeBool "EXTERNAL_FMT" true)
    (lib.cmakeBool "WITH_LUAJIT" withLuaJIT)
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://osm2pgsql.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      jglukasik
      das-g
    ];
    teams = [ lib.teams.geospatial ];
  };
})
