{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jportaudio";
  version = "0-unstable-2026-02-13";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "philburk";
    repo = "portaudio-java";
    rev = "d185a5322ecbe8bd209e14e7341fb73d0c7d2cc3";
    hash = "sha256-XG1bJm0hDSF4cE2OvQ5bvN8pmaKwIl9zDlsRCnTXnLc=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    # Prefer Ninja-backed CMake builds if available
    # (falls back to Makefiles when ninja is absent)
    # Add ninja to leverage standard CMake hooks without manual make calls
    ninja
    gradle
    jdk
  ];
  buildInputs = with pkgs; [ portaudio ];

  env = {
    JAVA_HOME = pkgs.jdk.home;
    GRADLE_HOME = pkgs.gradle;
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
