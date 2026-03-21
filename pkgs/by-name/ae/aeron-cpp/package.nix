{
  autoPatchelfHook,
  aeron,
  cmake,
  fetchFromGitHub,
  fetchMavenArtifact,
  fixDarwinDylibNames,
  jdk17,
  lib,
  libbsd,
  libuuid,
  makeWrapper,
  patchelf,
  stdenv,
  zlib,
}:

let
  version = aeron.version;

  sbeAll_1_37_1 = fetchMavenArtifact {
    groupId = "uk.co.real-logic";
    version = "1.37.1";
    artifactId = "sbe-all";
    hash = "sha256-IOsTkpJJCSoB/c0eg1GlWvgLq1QUqf2hnQ7d9vWYOmY=";
  };

  sbeAll = sbeAll_1_37_1;

in

stdenv.mkDerivation {
  pname = "aeron-cpp";
  inherit version;

  src = fetchFromGitHub {
    owner = "real-logic";
    repo = "aeron";
    tag = version;
    hash = "sha256-JTESN/dWXc/6X0lX4JRdBgC3Y+LYfhcpCaDnMq72Ffo=";
  };

  postPatch = ''
    # Replace aeron-all jar generation with a symbolic link
    # We use a simplified regex that matches the block
    sed -i '/add_custom_command(OUTPUT \''${AERON_ALL_JAR}/,/VERBATIM)/c\
    add_custom_command(OUTPUT ''${AERON_ALL_JAR}\
        COMMAND ln --symbolic ''${CMAKE_CURRENT_SOURCE_DIR}/aeron-all.jar ''${AERON_ALL_JAR}\
        DEPENDS ''${AERON_ALL_SOURCES}\
        WORKING_DIRECTORY ''${CMAKE_CURRENT_SOURCE_DIR}\
        COMMENT "Generating aeron-all jar"\
        VERBATIM)' CMakeLists.txt

    # Replace C Archive codecs generation with SBE call
    sed -i '/add_custom_command(OUTPUT \''${GENERATED_C_CODECS}/,/VERBATIM)/c\
    add_custom_command(OUTPUT \''${GENERATED_C_CODECS}\
        COMMAND \''${CMAKE_COMMAND} -E env JAVA_HOME=$ENV{JAVA_HOME} BUILD_JAVA_HOME=$ENV{BUILD_JAVA_HOME} BUILD_JAVA_VERSION=$ENV{BUILD_JAVA_VERSION} java -cp sbe.jar -Dsbe.output.dir=\''${ARCHIVE_CODEC_TARGET_DIR}/c -Dsbe.target.language=C -Dsbe.target.namespace=aeron_archive_client uk.co.real_logic.sbe.SbeTool \''${CODEC_SCHEMA}\
        DEPENDS \''${CODEC_SCHEMA} aeron-all-jar\
        WORKING_DIRECTORY \''${ARCHIVE_CODEC_WORKING_DIR}\
        COMMENT "Generating C Archive codecs"\
        VERBATIM)' aeron-archive/src/main/c/CMakeLists.txt

    # Fix the GENERATED_C_CODECS list in aeron-archive/src/main/c/CMakeLists.txt
    # Replace aeron_c_archive_client with c/aeron_archive_client
    sed -i 's/aeron_c_archive_client/c\/aeron_archive_client/g' aeron-archive/src/main/c/CMakeLists.txt
  '';

  buildInputs = [
    libbsd
    libuuid
    zlib
  ];

  nativeBuildInputs = [
    cmake
    jdk17
    makeWrapper
    patchelf
  ]
  ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ]
  ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
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

    ln --symbolic  "${aeron.jar}" ./aeron-all.jar
    ln --symbolic  "${sbeAll.jar}" ./sbe.jar
    mkdir --parents aeron-all/build/libs
    (
      cd cppbuild/Release

      make -j $NIX_BUILD_CORES \
        aeron \
        aeron_static \
        aeron_archive_c_client \
        aeron_archive_c_client_static \
        aeron_driver \
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

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for lib in $out/lib/*.dylib; do
      install_name_tool -change "@rpath/$(basename $lib)" "$lib" "$out/bin/aeronmd"
    done
  '';

  meta = {
    description = "Aeron Messaging C++ Library";
    homepage = "https://aeron.io/";
    license = lib.licenses.asl20;
    mainProgram = "aeronmd";
    maintainers = [ lib.maintainers.vaci ];
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryBytecode
    ];
  };
}
