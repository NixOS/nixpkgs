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
  openal,

  unstableGitUpdater,
}:

stdenv.mkDerivation {
  version = "0-unstable-2025-01-09";
  pname = "openrw";

  src = fetchFromGitHub {
    owner = "rwengine";
    repo = "openrw";
    rev = "556cdfbbf1fb5b3ddef5e43f36e97976be0252fc";
    fetchSubmodules = true;
    hash = "sha256-NYn89KGMITccVdqGo7NUS45HxXGurR9QDbVKEagjFqk=";
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
