{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
  cmake,
  pkg-config,
  makeWrapper,
  zlib,
  libx11,
  libxrandr,
  libxinerama,
  libxcursor,
  libxi,
  libxext,
  libGLU,
  alsa-lib,
  fontconfig,
  wayland,
  wayland-scanner,
  libdecor,
  libxkbcommon,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "foxotron";
  version = "2024-09-23-unstable-2026-03-20";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = "Foxotron";
    rev = "6edbf2e52e59a4206420bc667225a4e18778be76";
    fetchSubmodules = true;
    hash = "sha256-bqqtBXufeAncOQktpKFLkmc15p2Z8yrrGFLH62aXfj0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(CMAKE_OSX_ARCHITECTURES x86_64)" ""
  ''
  # From glfw package
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace externals/glfw/src/wl_init.c \
      --replace-fail '"libdecor-0.so.0"' '"${lib.getLib libdecor}/lib/libdecor-0.so.0"' \
      --replace-fail '"libwayland-client.so.0"' '"${lib.getLib wayland}/lib/libwayland-client.so.0"' \
      --replace-fail '"libwayland-cursor.so.0"' '"${lib.getLib wayland}/lib/libwayland-cursor.so.0"' \
      --replace-fail '"libwayland-egl.so.1"' '"${lib.getLib wayland}/lib/libwayland-egl.so.1"' \
      --replace-fail '"libxkbcommon.so.0"' '"${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0"'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland-scanner
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
    alsa-lib
    fontconfig
    libGLU
    libxkbcommon
    wayland
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-bounds"
  ];

  # error: writing 1 byte into a region of size 0
  hardeningDisable = [ "fortify3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/foxotron}
    cp -R ${lib.optionalString stdenv.hostPlatform.isDarwin "Foxotron.app/Contents/MacOS/"}Foxotron \
      ../{config.json,Shaders,Skyboxes} $out/lib/foxotron/
    wrapProgram $out/lib/foxotron/Foxotron \
      --chdir "$out/lib/foxotron"
    ln -s $out/{lib/foxotron,bin}/Foxotron

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "General purpose model viewer";
    longDescription = ''
      ASSIMP based general purpose model viewer ("turntable") created for the
      Revision 2021 3D Graphics Competition.
    '';
    homepage = "https://github.com/Gargaj/Foxotron";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
    mainProgram = "Foxotron";
  };
})
