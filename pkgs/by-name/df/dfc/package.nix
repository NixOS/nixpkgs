{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfc";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "rolinh";
    repo = "dfc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k15q04dNWmHVeUabaCogkESQ+k63ZV7Xph2SMNpV/N8=";
  };

  # Fix for CMake v4
  # ref. https://github.com/rolinh/dfc/pull/35
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8.4)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    gettext
  ];

  meta = {
    homepage = "https://github.com/rolinh/dfc";
    changelog = "https://github.com/rolinh/dfc/releases/tag/${finalAttrs.src.tag}";
    description = "Displays file system space usage using graphs and colors";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qknight ];
    platforms = lib.platforms.all;
    mainProgram = "dfc";
  };
})
