{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  ninja,

  # buildInputs
  SDL2,
  boost,
  bullet,
  ffmpeg_6,
  glm,
  libGL,
  libGLU,
  libmad,
  libX11,
  openal,

  unstableGitUpdater,
}:

stdenv.mkDerivation {
  version = "0-unstable-2025-06-18";
  pname = "openrw";

  src = fetchFromGitHub {
    owner = "rwengine";
    repo = "openrw";
    rev = "5c5f266b71aa55aeec8cb4d823f19e7c4348f3bd";
    fetchSubmodules = true;
    hash = "sha256-2fQQL0JoV8YukU+VW2iWS4DpBi1j361SfiXRHRmocRg=";
  };

  postPatch = lib.optional (stdenv.cc.isClang && (lib.versionAtLeast stdenv.cc.version "9")) ''
    substituteInPlace cmake_configure.cmake \
      --replace-fail 'target_link_libraries(rw_interface INTERFACE "stdc++fs")' ""
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    SDL2
    boost
    bullet
    ffmpeg_6
    glm
    libGL
    libGLU
    libmad
    libX11
    openal
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Unofficial open source recreation of the classic Grand Theft Auto III game executable";
    homepage = "https://github.com/rwengine/openrw";
    license = lib.licenses.gpl3;
    longDescription = ''
      OpenRW is an open source re-implementation of Rockstar Games' Grand Theft
      Auto III, a classic 3D action game first published in 2001.
    '';
    maintainers = with lib.maintainers; [ kragniz ];
    platforms = lib.platforms.all;
    mainProgram = "rwgame";
    badPlatforms = [
      # error: implicit instantiation of undefined template 'std::char_traits<unsigned short>'
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
