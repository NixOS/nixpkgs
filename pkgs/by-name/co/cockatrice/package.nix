{
  lib,
  stdenv,
  qt5,
  fetchFromGitHub,
  cmake,
  protobuf_21,
}:
let
  protobuf = protobuf_21;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cockatrice";
  version = "2026-05-08-Release-3.0.0";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = finalAttrs.version;
    sha256 = "sha256-jLHGWtHbJTQ5Gefrnd8aUq1K3f2QzyE4YU5bW//gH4Y=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
    protobuf
    qt5.qttools
    qt5.qtwebsockets
  ];

  meta = {
    homepage = "https://github.com/Cockatrice/Cockatrice";
    description = "Cross-platform virtual tabletop for multiplayer card games";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = with lib.platforms; linux;
  };
})
