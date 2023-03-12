{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, libGL
, libdrm
, mesa
, xorg
, wine
, wine64
}:

let
  arch = if stdenv.is32bit then "32" else "64";
in
stdenv.mkDerivation rec {
  pname = "wine-nine-standalone";
  version = "0.10-unstable";

  src = fetchFromGitHub {
    owner = "iXit";
    repo = pname;
    #rev = "v${version}"
    rev = "5ba57d60a351d87d3b2ef18acd8e43a15e2ece6b";
    hash = "sha256-3b0irtj5aDEXkpOZNJgw2Ba5RXnYA90mcmncNILIszM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    (if stdenv.is32bit then wine else wine64)
  ];
  buildInputs = [ libGL libdrm mesa.driversdev xorg.libX11 ];

  preConfigure = ''
    ./bootstrap.sh --distro nixos
  '';

  mesonFlags = [
    "--buildtype" "release"
    "--prefix" "${placeholder "out"}"
    "--cross-file" "tools/cross-wine${arch}"
  ];

  meta = {
    description = "Standalone Gallium Nine library for Wine";
    homepage = "https://github.com/iXit/wine-nine-standalone";
    changelog = "https://github.com/iXit/wine-nine-standalone/releases";
    maintainers = [ lib.maintainers.novenary ];
    license = lib.licenses.lgpl21Plus;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
