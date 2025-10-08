{
  lib,
  stdenv,
  fetchFromGitea,
  fetchpatch,
  cmake,
  libuuid,
  expat,
  libiconv,
  botan3,
  systemd,
  pkg-config,
  python3Packages,
  withIDN ? true,
  libidn,
  withPostgreSQL ? false,
  libpq,
  withSQLite ? true,
  sqlite,
  withUDNS ? true,
  udns,
}:

assert lib.assertMsg (
  withPostgreSQL || withSQLite
) "At least one Biboumi database provider required";

let
  catch = fetchFromGitea {
    domain = "codeberg.org";
    owner = "poezio";
    repo = "catch";
    tag = "v2.2.1";
    hash = "sha256-dGUnB/KPONqPno1aO5cOSiE5N4lUiTbMUcH0X6HUoCk=";
  };

  pname = "biboumi";
  version = "9.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "poezio";
    repo = "biboumi";
    tag = version;
    hash = "sha256-yjh9WFuFjaoZLfXTfZajmdRO+3KZqJYBEd0HgqcC28A=";
  };

  patches = [
    ./catch.patch
    (fetchpatch {
      name = "update_botan_to_version_3.patch";
      url = "https://codeberg.org/poezio/biboumi/commit/e4d32f939240ed726e9981e42c0dc251cd9879da.patch";
      hash = "sha256-QUt2ZQtoouLHAeEUlJh+yfCYEmLboL/tk6O2TbHR67Q=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.sphinx
  ];
  buildInputs = [
    libuuid
    expat
    libiconv
    systemd
    botan3
  ]
  ++ lib.optional withIDN libidn
  ++ lib.optional withPostgreSQL libpq
  ++ lib.optional withSQLite sqlite
  ++ lib.optional withUDNS udns;

  buildFlags = [
    "all"
    "man"
  ];

  cmakeFlags = [
    # Fix breakage with CMake 4
    "-DCMAKE_SKIP_RPATH=ON"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc/biboumi $out/etc/biboumi
    cp ${catch}/single_include/catch.hpp tests/
  '';

  doCheck = true;

  meta = {
    description = "Modern XMPP IRC gateway";
    mainProgram = "biboumi";
    platforms = lib.platforms.unix;
    homepage = "https://codeberg.org/poezio/biboumi";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.woffs ];
  };
}
