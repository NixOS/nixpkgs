{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  protobuf_21,
  libsForQt5,
}:

let
  protobuf = protobuf_21;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "cockatrice";
  version = "2025-04-03-Release-2.10.2";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    tag = "${finalAttrs.version}";
    hash = "sha256-zXAK830SdGT3xN3ST8h9LLy/oWr4MH6TZf57gLfI0e8=";
  };

  buildInputs = [
    protobuf
  ]
  ++ (with libsForQt5; [
    qtbase
    qtmultimedia
    qttools
    qtwebsockets
  ]);

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  meta = {
    homepage = "https://github.com/Cockatrice/Cockatrice";
    description = "Cross-platform virtual tabletop for multiplayer card games";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ evanjs ];
    mainProgram = "cockatrice";
    platforms = lib.platforms.linux;
  };
})
