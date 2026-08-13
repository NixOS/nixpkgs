{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  qt6,
  python3,

  # buildInputs
  eigen,
  parallel-hashmap,
  readerwriterqueue,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "forscape";
  version = "0.0.2-unstable-2025-04-28";

  src = fetchFromGitHub {
    owner = "JohnDTill";
    repo = "Forscape";
    rev = "1b6d82cdee7ed1ffeee8adffa56ca2b0a866cb34";
    hash = "sha256-Ee3SAFZG8I0ZEbggLVViqTYu4SFjNJ62xLcpfLgFlR0=";
  };
  cmakeFlags = [
    "-DUSE_CONAN=OFF"
  ];
  # Relative to build directory
  cmakeDir = "../app";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    python3
  ];

  buildInputs = [
    eigen
    parallel-hashmap
    readerwriterqueue
    qt6.qtbase
    qt6.qtsvg
  ];

  meta = {
    description = "Scientific computing language";
    homepage = "https://github.com/JohnDTill/Forscape";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "Forscape";
    platforms = lib.platforms.all;
  };
})
