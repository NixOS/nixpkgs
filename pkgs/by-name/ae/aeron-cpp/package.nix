{
  autoPatchelfHook,
  cmake,
  fetchFromGitHub,
  fetchMavenArtifact,
  jdk11,
  lib,
  libbsd,
  libuuid,
  makeWrapper,
  patchelf,
  stdenv,
  zlib
}:

let
  version = "1.42.1";

  aeronAll = fetchMavenArtifact {
    artifactId = "aeron-all";
    groupId = "io.aeron";
    inherit version;
    hash = "sha512-pjX+JopK6onDwElMIroj+ZXrKwdPj5H2uPg08XgNlrK1rAkHo9MUT8weBGbuFVFDLeqOZrHj0bt1wJ9XgYY5aA==";
  };

  sbeAll_1_29_0 = fetchMavenArtifact {
    groupId = "uk.co.real-logic";
    version = "1.29.0";
    artifactId = "sbe-all";
    hash = "sha512-exklKS9MgOH369lyuv+5vAWRHt+Iwg/FmsWy8PsSMjenvjs8I2KA1VTa00pIXkw/YNqbUDBIWvS07b4mS8YdPQ==";
  };

  sbeAll = sbeAll_1_29_0;

in

stdenv.mkDerivation {
  pname = "aeron-cpp";
  inherit version;

  src = fetchFromGitHub {
    owner = "real-logic";
    repo = "aeron";
    rev = version;
    hash = "sha256-ODJeJ4XLazPeNLdzaoclPnE59NpxFUqZu3Aw3iTVQT8=";
  };

  patches = [
    ./aeron-all.patch
    # Use pre-built aeron-all.jar from Maven repo, avoiding Gradle

    ./aeron-archive-sbe.patch
    # Use SBE tool to generate C++ codecs, avoiding Gradle
  ];

  buildInputs = [
    jdk11
    libbsd
    libuuid
    zlib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    makeWrapper
    patchelf
  ];

  configurePhase = ''
    runHook preConfigure

    mkdir --parents cppbuild/Release
    (
      cd cppbuild/Release
      cmake \
        -G "CodeBlocks - Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=Release \
        -DAERON_TESTS=OFF \
        -DAERON_SYSTEM_TESTS=OFF \
        -DAERON_BUILD_SAMPLES=OFF \
        -DCMAKE_INSTALL_PREFIX:PATH=../../install \
        ../..
    )

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ln --symbolic  "${aeronAll.jar}" ./aeron-all.jar
    ln --symbolic  "${sbeAll.jar}" ./sbe.jar
    mkdir --parents aeron-all/build/libs
    (
      cd cppbuild/Release

      make -j $NIX_BUILD_CORES \
        aeron \
        aeron_archive_client \
        aeron_client_shared \
        aeron_driver \
        aeron_client \
        aeron_driver_static \
        aeronmd

      make -j $NIX_BUILD_CORES install
    )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out"
    cp --archive --verbose --target-directory="$out" install/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Aeron Messaging C++ Library";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    mainProgram = "aeronmd";
    maintainers = [ maintainers.vaci ];
    sourceProvenance = [
      sourceTypes.fromSource
      sourceTypes.binaryBytecode
    ];
  };
}

