{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  sfml,
  libGLU,
  libGL,
  bullet,
  glm,
  libmad,
  openal,
  SDL2,
  boost,
  ffmpeg_6,
}:

stdenv.mkDerivation {
  version = "0-unstable-2025-01-09";
  pname = "openrw";

  src = fetchFromGitHub {
    owner = "rwengine";
    repo = "openrw";
    rev = "556cdfbbf1fb5b3ddef5e43f36e97976be0252fc";
    hash = "sha256-NYn89KGMITccVdqGo7NUS45HxXGurR9QDbVKEagjFqk=";
    fetchSubmodules = true;
  };

  postPatch = lib.optional (stdenv.cc.isClang && (lib.versionAtLeast stdenv.cc.version "9")) ''
    substituteInPlace cmake_configure.cmake \
      --replace 'target_link_libraries(rw_interface INTERFACE "stdc++fs")' ""
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    sfml
    libGLU
    libGL
    bullet
    glm
    libmad
    openal
    SDL2
    boost
    ffmpeg_6
  ];

  meta = with lib; {
    description = "Unofficial open source recreation of the classic Grand Theft Auto III game executable";
    homepage = "https://github.com/rwengine/openrw";
    license = licenses.gpl3;
    longDescription = ''
      OpenRW is an open source re-implementation of Rockstar Games' Grand Theft
      Auto III, a classic 3D action game first published in 2001.
    '';
    maintainers = with maintainers; [ kragniz ];
    platforms = platforms.all;
    mainProgram = "rwgame";
  };
}
