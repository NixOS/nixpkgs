{
  lib,
  gcc14Stdenv,
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
  patchelf,
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

gcc14Stdenv.mkDerivation rec {
  pname = "lovr";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "bjornbytes";
    repo = "lovr";
    rev = "v${version}";
    hash = "sha256-SyKJv9FmJyLGc3CT0JBNewvjtsmXKxiqaptysWiY4co=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Minimal
    makeWrapper
    patchelf
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

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    # LOVR's test/conf.lua disables graphics when CI is set
    export CI=1
    export HOME=$TMPDIR
    export LD_LIBRARY_PATH="${lib.makeLibraryPath runtimeLibs}:$(pwd)/bin"
    ./bin/lovr $src/test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib

    cp bin/lovr $out/bin/lovr-unwrapped
    for f in bin/lib*.so*; do
      cp "$f" $out/lib/
    done

    # Copy plugin modules (e.g. http.so, enet.so) next to the executable
    # where LOVR's libLoader expects to find them via dlopen.
    for f in bin/*.so; do
      # Skip lib*.so — those went to $out/lib/ above
      case "$(basename "$f")" in lib*) continue;; esac
      cp "$f" $out/bin/
    done

    patchelf --set-rpath "${lib.makeLibraryPath runtimeLibs}:$out/lib" $out/bin/lovr-unwrapped

    # Patch plugin modules so they don't reference /build/
    for f in $out/bin/*.so; do
      patchelf --set-rpath "${lib.makeLibraryPath runtimeLibs}:$out/lib" "$f" 2>/dev/null || true
    done

    for f in $out/lib/lib*.so*; do
      if [ -f "$f" ] && ! [ -L "$f" ]; then
        patchelf --set-rpath "${lib.makeLibraryPath runtimeLibs}:$out/lib" "$f" 2>/dev/null || true
      fi
    done

    # Wrap the binary so dlopen can find vulkan, audio backends, etc.
    makeWrapper $out/bin/lovr-unwrapped $out/bin/lovr \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:$out/lib"

    runHook postInstall
  '';

  meta = {
    description = "An open source framework for rapidly building immersive 3D experiences";
    homepage = "https://lovr.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crertel ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lovr";
  };
}
