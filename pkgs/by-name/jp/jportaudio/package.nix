{
  lib,
  stdenv,
  portaudio,
  jdk,
  cmake,
  ninja,
  gradle,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jportaudio";
  version = "0-unstable-2025-10-24";
  src = fetchFromGitHub {
    owner = "philburk";
    repo = "portaudio-java";
    rev = "ed2d3bc78b42f9c877863618b0ec4dac216102cc";
    hash = "sha256-tpJ4JqNFcuDmW70fLa0mW4fytjlU7h77IgMwS3msUX8=";
  };

  nativeBuildInputs = [
    cmake
    # Prefer Ninja-backed CMake builds if available
    # (falls back to Makefiles when ninja is absent)
    # Add ninja to leverage standard CMake hooks without manual make calls
    ninja
    gradle
    jdk
  ];
  buildInputs = [ portaudio ];

  env = {
    JAVA_HOME = jdk.home;
    GRADLE_HOME = gradle;
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  # Use standard CMake phases; run Gradle after native build via postBuild hook
  postBuild = ''
    : "${"cmakeBuildDir:=build"}"
    nativeLibDir="$PWD/native-libs"
    mkdir -p "$nativeLibDir"
    # Collect built native libraries from CMake build directory only
    if [ -d "$cmakeBuildDir" ]; then
      find "$cmakeBuildDir" -type f -name '*.so' -exec cp -v -n {} "$nativeLibDir/" \;
    fi

    export GRADLE_USER_HOME="$(mktemp -d)"
    # Run Gradle from source root
    sourceRoot="$NIX_BUILD_TOP/source"
    ( cd "$sourceRoot" && gradle --no-daemon -Djava.library.path="$nativeLibDir" assemble )
  '';

  # After CMake install, place built JARs into $out
  postInstall = ''
    : "${"cmakeBuildDir:=build"}"
    sourceRoot="$NIX_BUILD_TOP/source"
    mkdir -p "$out/share/java"
    if ls "$sourceRoot"/build/libs/*.jar >/dev/null 2>&1; then
      cp "$sourceRoot"/build/libs/*.jar "$out/share/java/"
    fi

    # Ensure unversioned symlink exists if only versioned lib was installed by CMake
    if [ ! -e "$out/lib/libjportaudio.so" ]; then
      candidate=$(ls "$out"/lib/libjportaudio*.so* 2>/dev/null | sort -V | tail -n1 || true)
      ln -s "$(basename "$candidate")" "$out/lib/libjportaudio.so"
    fi
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
      ];
    };
  };

  meta = {
    description = "Java wrapper for PortAudio audio library";
    homepage = "https://github.com/philburk/portaudio-java";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MiyakoMeow
      ungeskriptet
    ];
  };
})
