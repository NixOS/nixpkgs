{ lib, stdenv
, fetchFromGitHub
, cmake
, expat
, fmt
, proj
, bzip2
, cli11
, zlib
, boost
, postgresql
, python3
, withLuaJIT ? false
, lua
, luajit
, libosmium
, nlohmann_json
, opencv
, potrace
, protozero
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm2pgsql";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "osm2pgsql-dev";
    repo = "osm2pgsql";
    rev = finalAttrs.version;
    hash = "sha256-95B4WVaf3AwaC+S6dCJpUq/1J47rOZjWUBxmRqHCu4w=";
  };

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
    nlohmann_json
    opencv
    postgresql
    potrace
    proj
    protozero
    (python3.withPackages (p: with p; [ psycopg2 pyosmium ]))
    zlib
  ] ++ lib.optional withLuaJIT luajit
    ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    (lib.cmakeBool "EXTERNAL_LIBOSMIUM" true)
    (lib.cmakeBool "EXTERNAL_PROTOZERO" true)
    (lib.cmakeBool "EXTERNAL_FMT" true)
    (lib.cmakeBool "WITH_LUAJIT" withLuaJIT)
  ];

  installFlags = [ "install-gen" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://osm2pgsql.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; teams.geospatial.members ++ [ jglukasik das-g ];
  };
})
