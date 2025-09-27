{
  autoPatchelfHook,
  aeron,
  cmake,
  fetchFromGitHub,
  fetchMavenArtifact,
  jdk ? jdk17,
  jdk17,
  lib,
  libbsd,
  libuuid,
  makeWrapper,
  patchelf,
  stdenv,
  zlib,
  ninja,
}:

let
  version = aeron.version;

  sbeAll_1_31_1 = fetchMavenArtifact {
    groupId = "uk.co.real-logic";
    version = "1.31.1";
    artifactId = "sbe-all";
    hash = "sha512-Ypsk8PbShFOxm49u1L+TTuApaW6ECTSee+hHEhmY/jNi5AymHXBWwDMBMkzC25aowiHLJS5EnzLk6hu9Lea93Q==";
  };

  sbeAll_1_34_1 = fetchMavenArtifact {
    groupId = "uk.co.real-logic";
    version = "1.34.1";
    artifactId = "sbe-all";
    hash = "sha512-Z0zBQrrqJSjfkUADhIANskIUb+FgOto5kr1+Y3Lw9RhSAxslaP+NdB705RdITC/kq7qTMlUstc2xM797dE/6BA==";
  };

  sbeAll = sbeAll_1_34_1;

in
stdenv.mkDerivation {
  pname = "aeron-cpp";
  inherit version;

  src = fetchFromGitHub {
    owner = "real-logic";
    repo = "aeron";
    rev = version;
    hash = "sha256-sROEZVOfScrlqMLbfrPtw3LQCQ5TfMcrLiP6j/Z9rSM=";
  };

  patches = [
    ./aeron-all.patch
    # Use pre-built aeron-all.jar from Maven repo, avoiding Gradle

    ./aeron-archive-sbe.patch
    # Use SBE tool to generate C++ codecs, avoiding Gradle
  ];

  buildInputs = [
    libbsd
    libuuid
    zlib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    jdk
    makeWrapper
    ninja
    patchelf
  ];

  configurePhase = ''
    runHook preConfigure

    mkdir --parents cppbuild/Release
    (
      cd cppbuild/Release
      cmake \
        -G Ninja \
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

    ln --symbolic  "${aeron.jar}" ./aeron-all.jar
    ln --symbolic  "${sbeAll.jar}" ./sbe.jar
    mkdir --parents aeron-all/build/libs
    (
      cd cppbuild/Release
      ninja -j $NIX_BUILD_CORES \
        aeron \
        aeron_archive_client \
        aeron_client_shared \
        aeron_driver \
        aeron_client \
        aeron_driver_static \
        aeronmd
      ninja install
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
