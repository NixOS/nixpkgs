{
  lib,
  stdenv,
  portaudio,
  jdk,
  cmake,
  gradle,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "portaudio-java";
  version = "0-unstable-2023-07-04";
  src = fetchFromGitHub {
    owner = "philburk";
    repo = "portaudio-java";
    rev = "2ec5cc47d6f8abe85ddb09c34e69342bfe72c60b";
    hash = "sha256-t+Pqtgstd1uJjvD4GKomZHMeSECNLeQJOrz97o+lV2Q=";
  };

  nativeBuildInputs = [
    cmake
    gradle
    jdk
  ];
  buildInputs = [ portaudio ];

  # Set up necessary environment variables
  env = {
    JAVA_HOME = jdk.home;
    GRADLE_HOME = gradle;
  };

  # Fix CMake installation path issue
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    # Fix gradlew cannot find library issue
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  configurePhase = ''
    cmake . $cmakeFlags
  '';

  buildPhase = ''
    # Only build, do not install
    make

    # Key modification 1: Manually locate and prepare library files
    JNI_LIB_DIR=$(find . -type d -path "*/jni" | head -1)
    mkdir -p native-libs
    find $JNI_LIB_DIR -name '*.so' -exec cp {} native-libs/ \;

    # Key modification 2: Set Java and JNI library paths
    export JAVA_LIBRARY_PATH=$PWD/native-libs:$JAVA_LIBRARY_PATH
    export LD_LIBRARY_PATH=$PWD/native-libs:$LD_LIBRARY_PATH

    # Build Java part
    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --no-daemon -Djava.library.path=$PWD/native-libs assemble
  '';

  installPhase = ''
    echo "Installing jportaudio..."

    # Install JAR files
    mkdir -p $out/share/java
    cp build/libs/*.jar $out/share/java/

    # Install native libraries
    mkdir -p $out/lib
    cp ./*.so $out/lib/

    # Find the highest version of libjportaudio*.so
    LIB_FILE=$(ls $out/lib/libjportaudio*.so 2>/dev/null | sort -V | tail -1)
    if [ -n "$LIB_FILE" ]; then
      ln -sf "$LIB_FILE" $out/lib/libjportaudio.so
    else
      echo "No libjportaudio*.so files found!"
      return 1
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
    maintainers = with lib.maintainers; [ MiyakoMeow ];
  };
})
