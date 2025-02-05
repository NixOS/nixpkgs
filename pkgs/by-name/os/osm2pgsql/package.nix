{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  expat,
  fmt_11,
  proj,
  bzip2,
  cli11,
  zlib,
  boost,
  postgresql,
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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "osm2pgsql-dev";
    repo = "osm2pgsql";
    rev = finalAttrs.version;
    hash = "sha256-+EFvYloLm/cDOflqj6ZIgjFoljKhYBVIKxD8L9j2Hj4=";
  };

  postPatch = ''
    # Remove bundled libraries
    rm -r contrib
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [
      boost
      bzip2
      cli11
      expat
      fmt_11
      libosmium
      nlohmann_json
      opencv
      postgresql
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
    maintainers =
      lib.teams.geospatial.members
      ++ (with lib.maintainers; [
        jglukasik
        das-g
      ]);
  };
})
