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
stdenv.mkDerivation rec {
  pname = "cockatrice";
  version = "2025-04-03-Release-2.10.2";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = version;
    sha256 = "sha256-zXAK830SdGT3xN3ST8h9LLy/oWr4MH6TZf57gLfI0e8=";
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
}
