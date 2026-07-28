{
  lib,
  gcc14Stdenv, # done for better C++ support in the project
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3Minimal,
  makeWrapper,
  libx11,
  libxrandr,
  libxinerama,
  libxcursor,
  libxi,
  libxcb,
  libxext,
  libxkbcommon,
  vulkan-headers,
  vulkan-loader,
  libGL,
  curl,
  autoPatchelfHook,
  alsa-lib,
  libpulseaudio,
}:

let
  # JoltPhysics is fetched at build time via FetchContent in deps/joltc/CMakeLists.txt.
  # Pre-fetch it here and pass via FETCHCONTENT_SOURCE_DIR_JOLTPHYSICS to avoid network access.
  joltphysics-src = fetchFromGitHub {
    owner = "jrouwe";
    repo = "JoltPhysics";
    rev = "c10d9b2a8ee134fb5e72de1a0f26f8c9cc8f6382";
    hash = "sha256-owI9uM/hjicuUWXYeZOhfYby5ygWm3JOO/qifRGiOdM=";
  };

  # Libraries that LOVR loads at runtime via dlopen
  runtimeLibs = [
    vulkan-loader
    libGL
    libx11
    libxcb
    gcc14Stdenv.cc.cc.lib
    alsa-lib
    libpulseaudio
    curl
  ];
in

gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "lovr";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "bjornbytes";
    repo = "lovr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SyKJv9FmJyLGc3CT0JBNewvjtsmXKxiqaptysWiY4co=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Minimal
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxcb
    libxext
    libxkbcommon
    vulkan-headers
    vulkan-loader
    libGL
    curl
  ];

  cmakeFlags = [
    "-DLOVR_USE_STEAM_AUDIO=OFF"
    "-DLOVR_USE_OCULUS_AUDIO=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_JOLTPHYSICS=${joltphysics-src}"
  ];

  installCheckPhase = ''
    runHook preInstallCheck
    # LOVR's test/conf.lua disables graphics when CI is set
    export CI=1
    export HOME=$TMPDIR
    $out/bin/lovr $src/test
    runHook postInstallCheck
  '';

  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/libexec

    cp bin/lovr $out/libexec/lovr
    for f in bin/lib*.so*; do
      mv "$f" $out/lib/
    done

    # move plugin modules (e.g. http.so, enet.so) next to the executable
    # where LOVR's libLoader expects to find them via dlopen.
    for f in bin/*.so; do
      mv "$f" $out/libexec/
    done

    # zorch stale plugin rpaths so we can get them at fixup
    for f in $out/libexec/*.so; do
      patchelf --remove-rpath "$f"
    done

    # wrap the binary so dlopen can find vulkan, audio backends, etc.
    # the LD_LIBRARY_PATH is sorta load bearing, so don't kill it
    # it needs to be suffixed to use the system audio properly (prefix doesn't work)
    makeWrapper $out/libexec/lovr $out/bin/lovr \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:$out/lib"

    runHook postInstall
  '';

  dontUseCmakeInstall = true;

  meta = {
    description = "An open source framework for rapidly building immersive 3D experiences";
    homepage = "https://lovr.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crertel ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lovr";
  };
})
