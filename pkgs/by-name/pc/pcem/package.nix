{
  stdenv,
  lib,
  fetchFromGitHub,
  wxwidgets_3_2,
  cmake,
  SDL2,
  openal,
  alsa-lib,
  libGL,
  libpcap,
  libslirp,
  pkg-config,
  gtk3,
  wrapGAppsHook3,
  withNetworking ? true,
}:
stdenv.mkDerivation {
  pname = "pcem";
  version = "17-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "sarah-walker-pcem";
    repo = "pcem";
    rev = "711eebf6ba2b15866b8e77b9de705c753be957db";
    hash = "sha256-zpFLatEPxXfsqRB8qXAeuBZ1WyFePPEqwZsT+TjBxWQ=";
  };

  postPatch = ''
    # uint64_t is used without including relevant header
    substituteInPlace src/wx-ui/wx-hdgeometry.cc \
      --replace-fail '#include <stdio.h>' '#include <stdio.h>
    #include <stdint.h>'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    wxwidgets_3_2
    SDL2
    openal
    gtk3
    libGL
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optionals withNetworking [
    libpcap
    libslirp
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_NETWORKING" withNetworking)
    (lib.cmakeFeature "CMAKE_C_STANDARD" "17")
  ]
  ++ lib.optional stdenv.hostPlatform.isx86_64 (lib.cmakeFeature "PCEM_MARCH" "x86-64");

  meta = {
    description = "Emulator for IBM PC computers and clones";
    mainProgram = "pcem";
    homepage = "https://pcem-emulator.co.uk/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.terin ];
    platforms = lib.platforms.linux ++ lib.platforms.windows;
  };
}
