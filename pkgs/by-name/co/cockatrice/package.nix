{
  lib,
  stdenv,
  qt6,
  fetchFromGitHub,
  cmake,
  protobuf,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cockatrice";
  version = "2026-10-25-Release-3.1.2";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = finalAttrs.version;
    sha256 = "sha256-yyvdg1PFdNnSGqXW37AebjA6sH3XadCBQI6AvdFwCPQ=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    protobuf
    qt6.qttools
    qt6.qtwebsockets
  ];

  meta = {
    homepage = "https://github.com/Cockatrice/Cockatrice";
    description = "Cross-platform virtual tabletop for multiplayer card games";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = with lib.platforms; linux;
  };
})
