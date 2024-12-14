{
  lib,
  stdenv,
  fetchurl,
  fetchgit,
  cmake,
  libuuid,
  expat,
  sqlite,
  libidn,
  libiconv,
  botan2,
  systemd,
  pkg-config,
  udns,
  python3Packages,
}:

let
  louiz_catch = fetchgit {
    url = "https://lab.louiz.org/louiz/Catch.git";
    rev = "0a34cc201ef28bf25c88b0062f331369596cb7b7"; # v2.2.1
    sha256 = "0ad0sjhmzx61a763d2ali4vkj8aa1sbknnldks7xlf4gy83jfrbl";
  };
in
stdenv.mkDerivation rec {
  pname = "biboumi";
  version = "9.0";

  src = fetchurl {
    url = "https://git.louiz.org/biboumi/snapshot/biboumi-${version}.tar.xz";
    sha256 = "1jvygri165aknmvlinx3jb8cclny6cxdykjf8dp0a3l3228rmzqy";
  };

  patches = [ ./catch.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.sphinx
  ];
  buildInputs = [
    libuuid
    expat
    sqlite
    libiconv
    libidn
    botan2
    systemd
    udns
  ];

  buildFlags = [
    "all"
    "man"
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc/biboumi $out/etc/biboumi
    cp ${louiz_catch}/single_include/catch.hpp tests/
  '';

  doCheck = true;

  meta = with lib; {
    description = "Modern XMPP IRC gateway";
    mainProgram = "biboumi";
    platforms = platforms.unix;
    homepage = "https://lab.louiz.org/louiz/biboumi";
    license = licenses.zlib;
    maintainers = [ maintainers.woffs ];
  };
}
