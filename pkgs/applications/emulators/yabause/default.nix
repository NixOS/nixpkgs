{
  mkDerivation,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  qtbase,
  qt5,
  libGLU,
  libGL,
  libglut ? null,
  openal ? null,
  SDL2 ? null,
}:

mkDerivation rec {
  pname = "yabause";
  version = "0.9.15";

  src = fetchurl {
    url = "https://web.archive.org/web/20250129091147/http://free.downloads.tuxfamily.net/yabause/releases/${version}/yabause-${version}.tar.gz";
    sha256 = "1cn2rjjb7d9pkr4g5bqz55vd4pzyb7hg94cfmixjkzzkw0zw8d23";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    qtbase
    qt5.qtmultimedia
    libGLU
    libGL
    libglut
    openal
    SDL2
  ];

  patches = [
    ./linkage-rwx-linux-elf.patch
    # Fixes derived from
    # https://github.com/Yabause/yabause/commit/06a816c032c6f7fd79ced6e594dd4b33571a0e73
    ./0001-Fixes-for-Qt-5.11-upgrade.patch
  ];

  cmakeFlags = [
    "-DYAB_NETWORK=ON"
    "-DYAB_OPTIMIZED_DMA=ON"
    "-DYAB_PORTS=qt"
    "-DSH2_DYNAREC=OFF" # https://github.com/Yabause/yabause/issues/270
  ];

  postPatch = ''
    substituteInPlace {./,src/,src/runner/}CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace src/{c68k,musashi}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "Open-source Sega Saturn emulator";
    mainProgram = "yabause";
    homepage = "https://yabause.org/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
