{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  unzip,
  makeWrapper,
  gradle_8,
  jdk17,
  jogl,
  rsync,
  batik,
  stripJavaArchivesHook,
  wrapGAppsHook3,
  libGL,
}:
let
  # Force use of JDK 17, see https://github.com/processing/processing4/issues/1043
  gradle = gradle_8.override { java = jdk17; };
  jdk = jdk17;
  buildNumber = "1310";
  vaqua = fetchurl {
    name = "VAqua9.jar";
    url = "https://violetlib.org/release/vaqua/9/VAqua9.jar";
    sha256 = "cd0b82df8e7434c902ec873364bf3e9a3e6bef8b59cbf42433130d71bf1a779c";
  };

  jna = fetchurl {
    name = "jna-5.10.0.zip";
    url = "https://github.com/java-native-access/jna/archive/5.10.0.zip";
    sha256 = "B5CakOQ8225xNsk2TMV8CbK3RcsLlb+pHzjaY5JNwg0=";
  };

  flatlaf = fetchurl {
    name = "flatlaf-2.4.jar";
    url = "mirror://maven/com/formdev/flatlaf/2.4/flatlaf-2.4.jar";
    sha256 = "NVMYiCd+koNCJ6X3EiRx1Aj+T5uAMSJ9juMmB5Os+zc=";
  };

  lsp4j = fetchurl {
    name = "org.eclipse.lsp4j-0.19.0.jar";
    url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j/0.19.0/org.eclipse.lsp4j-0.19.0.jar";
    sha256 = "sha256-1DI5D9KW+GL4gT1qjwVZveOl5KVOEjt6uXDwsFzi8Sg=";
  };

  lsp4j-jsonrpc = fetchurl {
    name = "org.eclipse.lsp4j.jsonrpc-0.19.0.jar";
    url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.jsonrpc/0.19.0/org.eclipse.lsp4j.jsonrpc-0.19.0.jar";
    sha256 = "sha256-ozYTkvv7k0psCeX/PbSM3/Bl17qT3upX3trt65lmM9I=";
  };

  gson = fetchurl {
    name = "gson-2.9.1.jar";
    url = "mirror://maven/com/google/code/gson/gson/2.9.1/gson-2.9.1.jar";
    sha256 = "sha256-N4U04znm5tULFzb7Ort28cFdG+P0wTzsbVNkEuI9pgM=";
  };
in
stdenv.mkDerivation rec {
  pname = "processing";
  version = "4.4.10";

  src = fetchFromGitHub {
    owner = "processing";
    repo = "processing4";
    rev = "processing-${buildNumber}-${version}";
    sha256 = "sha256-u2wQl/VGCNJPd+k3DX2eW7gkA/RARMTSNGcoQuS/Oh8=";
  };

  patches = [
    ./skip-distributable.patch

    # dirPermissions: Without this, some gradle tasks (e.g. includeJdk) fail to copy contents of read-only subfolders within the nix store
    ./fix-permissions.patch
  ];

  nativeBuildInputs = [
    gradle
    unzip
    makeWrapper
    stripJavaArchivesHook
    wrapGAppsHook3
  ];
  buildInputs = [
    jdk
    jogl
    rsync
    batik
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  gradleBuildTask = "createDistributable";
  gradleUpdateTask = "createDistributable";
  enableParallelUpdating = false;

  # Need to run the entire createDistributable task, otherwise the buildPhase fails at the compose checkRuntime step
  gradleUpdateScript = ''
    runHook preBuild
    runHook preGradleUpdate

    mkdir -p app/lib core/library
    ln -s ${jogl}/share/java/* core/library/
    ln -s ${vaqua} app/lib/VAqua9.jar
    ln -s ${flatlaf} app/lib/flatlaf.jar
    ln -s ${lsp4j} java/mode/org.eclipse.lsp4j.jar
    ln -s ${lsp4j-jsonrpc} java/mode/org.eclipse.lsp4j.jsonrpc.jar
    ln -s ${gson} java/mode/gson.jar
    unzip -qo ${jna} -d app/lib/
    mv app/lib/{jna-5.10.0/dist/jna.jar,}
    mv app/lib/{jna-5.10.0/dist/jna-platform.jar,}

    ln -sf ${batik}/* java/libraries/svg/library/
    cp java/libraries/svg/library/share/java/batik-all-${batik.version}.jar java/libraries/svg/library/batik.jar

    gradle createDistributable

    runHook postGradleUpdate
  '';

  dontWrapGApps = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p app/lib core/library
    ln -s ${jogl}/share/java/* core/library/
    ln -s ${vaqua} app/lib/VAqua9.jar
    ln -s ${flatlaf} app/lib/flatlaf.jar
    ln -s ${lsp4j} java/mode/org.eclipse.lsp4j.jar
    ln -s ${lsp4j-jsonrpc} java/mode/org.eclipse.lsp4j.jsonrpc.jar
    ln -s ${gson} java/mode/gson.jar
    unzip -qo ${jna} -d app/lib/
    mv app/lib/{jna-5.10.0/dist/jna.jar,}
    mv app/lib/{jna-5.10.0/dist/jna-platform.jar,}

    ln -sf ${batik}/* java/libraries/svg/library/
    cp java/libraries/svg/library/share/java/batik-all-${batik.version}.jar java/libraries/svg/library/batik.jar

    gradle assemble

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    gradle createDistributable

    mkdir -p $out/lib
    cp -dpr app/build/compose/binaries/main/app/Processing/lib/* $out/lib/
    cp -dpr app/build/compose/binaries/main/app/Processing/bin $out/unwrapped

    mkdir -p $out/share/applications/
    cp -dp build/linux/${pname}.desktop $out/share/applications/

    rm -r $out/lib/app/resources/jdk
    ln -s ${jdk}/lib/openjdk $out/lib/app/resources/jdk

    makeWrapper $out/unwrapped/Processing $out/bin/Processing \
      ''${gappsWrapperArgs[@]} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Language and IDE for electronic arts";
    homepage = "https://processing.org";
    license = with licenses; [
      gpl2Only
      lgpl21Only
    ];
    mainProgram = "Processing";
    platforms = platforms.linux;
    maintainers = with maintainers; [ evan-goode ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
