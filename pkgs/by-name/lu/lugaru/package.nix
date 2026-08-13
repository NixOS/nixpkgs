{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  openal,
  pkg-config,
  libogg,
  libvorbis,
  SDL2,
  makeWrapper,
  libpng,
  libjpeg_turbo,
  libGLU,
}:

let
  inherit (lib)
    licenses
    maintainers
    platforms
    ;
in

stdenv.mkDerivation rec {

  pname = "lugaru";
  version = "1.2";

  src = fetchFromGitLab {
    owner = "osslugaru";
    repo = "lugaru";
    rev = version;
    sha256 = "089rblf8xw3c6dq96vnfla6zl8gxcpcbc1bj5jysfpq63hhdpypz";
  };

  nativeBuildInputs = [
    makeWrapper
    cmake
    pkg-config
  ];

  buildInputs = [
    libGLU
    openal
    SDL2
    libogg
    libvorbis
    libpng
    libjpeg_turbo
  ];

  cmakeFlags = [ "-DSYSTEM_INSTALL=ON" ];

  # CMake 3.0 is deprecated and no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.0)" \
      "cmake_minimum_required(VERSION 3.10)" \
    --replace-fail \
      "cmake_policy(SET CMP0004 OLD)" ""
  '';

  meta = {
    description = "Third person ninja rabbit fighting game";
    mainProgram = "lugaru";
    homepage = "https://osslugaru.gitlab.io";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
