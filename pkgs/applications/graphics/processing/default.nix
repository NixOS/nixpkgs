{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  ant,
  unzip,
  makeWrapper,
  jdk,
  jogl,
  rsync,
  ffmpeg,
  batik,
  stripJavaArchivesHook,
  wrapGAppsHook3,
  libGL,
}:
let
  buildNumber = "1294";
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

  arch =
    {
      x86_64 = "amd64";
    }
    .${stdenv.hostPlatform.parsed.cpu.name} or stdenv.hostPlatform.parsed.cpu.name;
in
stdenv.mkDerivation rec {
  pname = "processing";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "processing";
    repo = "processing4";
    rev = "processing-${buildNumber}-${version}";
    sha256 = "sha256-nshhPeDXhrvk+2oQ9BPqJTZV9a+OjxeQiO31JAxQ40g=";
  };

  nativeBuildInputs = [
    ant
    unzip
    makeWrapper
    stripJavaArchivesHook
    wrapGAppsHook3
  ];
  buildInputs = [
    jdk
    jogl
    ant
    rsync
    ffmpeg
    batik
  ];

  dontWrapGApps = true;

  buildPhase = ''
    runHook preBuild

    echo "tarring jdk"
    tar --checkpoint=10000 -czf build/linux/jdk-17.0.8-${arch}.tgz ${jdk}
    cp ${ant.home}/lib/{ant.jar,ant-launcher.jar} app/lib/
    mkdir -p core/library
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
    echo "tarring ffmpeg"
    tar --checkpoint=10000 -czf build/shared/tools/MovieMaker/ffmpeg-5.0.1.gz ${ffmpeg}
    cd build
    ant build
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    mkdir -p $out/share/applications/
    cp -dp build/linux/${pname}.desktop $out/share/applications/
    cp -dpr build/linux/work $out/share/${pname}
    rmdir $out/share/${pname}/java
    ln -s ${jdk} $out/share/${pname}/java
    makeWrapper $out/share/${pname}/processing $out/bin/processing \
      ''${gappsWrapperArgs[@]} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd
    makeWrapper $out/share/${pname}/processing-java $out/bin/processing-java \
      ''${gappsWrapperArgs[@]} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd

    runHook postInstall
  '';

  meta = with lib; {
    description = "Language and IDE for electronic arts";
    homepage = "https://processing.org";
    license = with licenses; [
      gpl2Only
      lgpl21Only
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ evan-goode ];
  };
}
