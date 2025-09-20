{
  autoPatchelfHook,
  aeron,
  cmake,
  fetchFromGitHub,
  fetchMavenArtifact,
  jdk11,
  lib,
  libbsd,
  libuuid,
  stdenv,
  zlib,
}:
let
  sbeAll = fetchMavenArtifact {
    groupId = "uk.co.real-logic";
    version = "1.31.1";
    artifactId = "sbe-all";
    hash = "sha512-Ypsk8PbShFOxm49u1L+TTuApaW6ECTSee+hHEhmY/jNi5AymHXBWwDMBMkzC25aowiHLJS5EnzLk6hu9Lea93Q==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aeron-cpp";
  inherit (aeron) version;

  src = fetchFromGitHub {
    owner = "real-logic";
    repo = "aeron";
    rev = finalAttrs.version;
    hash = "sha256-sROEZVOfScrlqMLbfrPtw3LQCQ5TfMcrLiP6j/Z9rSM=";
  };

  patches = [
    # Use pre-built aeron-all.jar from Maven repo, avoiding Gradle
    ./aeron-all.patch
    # Use SBE tool to generate C++ codecs, avoiding Gradle
    ./aeron-archive-sbe.patch
  ];

  buildInputs = [
    libbsd
    libuuid
    zlib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    jdk11
  ];

  configurePhase = ''
    runHook preConfigure

    mkdir --parents cppbuild/Release
    (
      cd cppbuild/Release
      cmake \
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

    ln --symbolic "${aeron.jar}" ./aeron-all.jar
    ln --symbolic "${sbeAll.jar}" ./sbe.jar

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

      make install
    )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out"
    cp --archive --verbose --target-directory="$out" install/*

    runHook postInstall
  '';

  meta = {
    description = "Aeron Messaging C++ Library";
    homepage = "https://aeron.io/";
    license = lib.licenses.asl20;
    mainProgram = "aeronmd";
    maintainers = with lib.maintainers; [ vaci ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
