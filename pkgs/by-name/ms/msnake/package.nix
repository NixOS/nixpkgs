{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msnake";
  # last release tag was 13 years ago
  version = "0.1.1-unstable-2020-02-01";

  src = fetchFromGitHub {
    owner = "mogria";
    repo = "msnake";
    rev = "830967fc8195216120fedcac1574113b367a0f9a";
    hash = "sha256-5q3yT7amPF+SSvO6/eUU7IiK0k6f3nme9YYBUobSuuo=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8.4)" \
      "cmake_minimum_required(VERSION 4.0)"
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    ncurses
  ];

  meta = {
    description = "Multiplatform command line snake game";
    homepage = "https://github.com/mogria/msnake";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "msnake";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
