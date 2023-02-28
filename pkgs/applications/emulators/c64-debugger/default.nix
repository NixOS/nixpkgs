{ lib
, stdenv
, fetchgit
, alsa-lib
, gtk3
, libGL
, libGLU
, libX11
, pkg-config
, upx
, xcbutil
}:

stdenv.mkDerivation {
  name = "c64-debugger";
  version = "0.64.58.6";

  src = fetchgit {
    url = "https://git.code.sf.net/p/c64-debugger/code";
    rev = "f97772e3f5c8b4fa99e8ed212ed1c4cb1e2389f1";
    sha256 = "sha256-3SR73AHQlYSEYpJLtQ/aJ1UITZGq7aA9tQKxBsn/yuc=";
  };

  buildInputs = [
    alsa-lib
    gtk3
    libGL
    libGLU
    pkg-config
    libX11
    xcbutil
  ];

  nativeBuildInputs = [
    upx
  ];

  postPatch = ''
    # Disable default definition of RUN_COMMODORE64
    sed -i 's|^#define RUN_COMMODORE64|//#define RUN_COMMODORE64|' MTEngine/Games/c64/C64D_Version.h
  '';

  buildPhase = ''
    runHook preBuild

    # Build C64 debugger
    make -C MTEngine \
      CFLAGS="-w -O2 -fcommon" \
      CXXFLAGS="-w -O2 --std=c++11" \
      DEFINES="-DRUN_COMMODORE64" \
      -j$NIX_BUILD_CORES
    mv MTEngine/c64debugger c64debugger
    make -C MTEngine clean

    # Build 65XE debugger
    make -C MTEngine \
      CFLAGS="-w -O2 -fcommon" \
      CXXFLAGS="-w -O2 --std=c++11" \
      DEFINES="-DRUN_ATARI" \
      -j$NIX_BUILD_CORES
    mv MTEngine/c64debugger 65xedebugger
    make -C MTEngine clean

    # Build NES debugger
    make -C MTEngine \
      CFLAGS="-w -O2 -fcommon" \
      CXXFLAGS="-w -O2 --std=c++11" \
      DEFINES="-DRUN_NES" \
      -j$NIX_BUILD_CORES
    mv MTEngine/c64debugger nesdebugger

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d "$out/bin"
    install -d "$out/share/doc"
    install -m 755 c64debugger 65xedebugger nesdebugger "$out/bin"
    install -m 644 MTEngine/Assets/*.txt "$out/share/doc"
    install -m 644 MTEngine/Assets/*.pdf "$out/share/doc"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/c64-debugger";
    description = "Commodore 64, Atari XL/XE and NES code and memory debugger that works in real time";
    license = with licenses; [
      gpl3Only # c64-debugger
      mit # MTEngine
      # emulators included in c64-debugger
      gpl2Plus # VICE, atari800
      gpl2 # nestopiaue
    ];
    mainProgram = "c64debugger";
    maintainers = [ maintainers.detegr ];
    platforms = platforms.linux;
  };
}
