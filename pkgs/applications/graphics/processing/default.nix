{ lib, stdenv, fetchFromGitHub, fetchurl, ant, unzip, makeWrapper, jdk, javaPackages, rsync, ffmpeg, batik, gsettings-desktop-schemas, xorg, wrapGAppsHook }:
let
  buildNumber = "1292";
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
    url = "https://repo1.maven.org/maven2/com/formdev/flatlaf/2.4/flatlaf-2.4.jar";
    sha256 = "NVMYiCd+koNCJ6X3EiRx1Aj+T5uAMSJ9juMmB5Os+zc=";
  };

  lsp4j = fetchurl {
    name = "org.eclipse.lsp4j-0.19.0.jar";
    url = "https://repo1.maven.org/maven2/org/eclipse/lsp4j/org.eclipse.lsp4j/0.19.0/org.eclipse.lsp4j-0.19.0.jar";
    sha256 = "sha256-1DI5D9KW+GL4gT1qjwVZveOl5KVOEjt6uXDwsFzi8Sg=";
  };

  lsp4j-jsonrpc = fetchurl {
    name = "org.eclipse.lsp4j.jsonrpc-0.19.0.jar";
    url = "https://repo1.maven.org/maven2/org/eclipse/lsp4j/org.eclipse.lsp4j.jsonrpc/0.19.0/org.eclipse.lsp4j.jsonrpc-0.19.0.jar";
    sha256 = "sha256-ozYTkvv7k0psCeX/PbSM3/Bl17qT3upX3trt65lmM9I=";
  };

  gson = fetchurl {
    name = "gson-2.9.1.jar";
    url = "https://repo1.maven.org/maven2/com/google/code/gson/gson/2.9.1/gson-2.9.1.jar";
    sha256 = "sha256-N4U04znm5tULFzb7Ort28cFdG+P0wTzsbVNkEuI9pgM=";
  };

  arch = {
    x86_64 = "amd64";
  }.${stdenv.hostPlatform.parsed.cpu.name} or stdenv.hostPlatform.parsed.cpu.name;
in
stdenv.mkDerivation rec {
  pname = "processing";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "processing";
    repo = "processing4";
    rev = "processing-${buildNumber}-${version}";
    sha256 = "sha256-wdluhrtliLN4T2dcmwvUWZhOARC3Lst7+hWWwZjafmU=";
  };

  nativeBuildInputs = [ ant unzip makeWrapper wrapGAppsHook ];
  buildInputs = [ jdk javaPackages.jogl_2_4_0 ant rsync ffmpeg batik ];

  dontWrapGApps = true;

  buildPhase = ''
    echo "tarring jdk"
    tar --checkpoint=10000 -czf build/linux/jdk-17.0.6-${arch}.tgz ${jdk}
    cp ${ant}/lib/ant/lib/{ant.jar,ant-launcher.jar} app/lib/
    mkdir -p core/library
    ln -s ${javaPackages.jogl_2_4_0}/share/java/* core/library/
    ln -s ${vaqua} app/lib/VAqua9.jar
    ln -s ${flatlaf} app/lib/flatlaf.jar
    ln -s ${lsp4j} java/mode/org.eclipse.lsp4j.jar
    ln -s ${lsp4j-jsonrpc} java/mode/org.eclipse.lsp4j.jsonrpc.jar
    ln -s ${gson} java/mode/gson.jar
    unzip -qo ${jna} -d app/lib/
    mv app/lib/{jna-5.10.0/dist/jna.jar,}
    mv app/lib/{jna-5.10.0/dist/jna-platform.jar,}
    ln -sf ${batik}/* java/libraries/svg/library/
    cp java/libraries/svg/library/lib/batik-all-${batik.version}.jar java/libraries/svg/library/batik.jar
    echo "tarring ffmpeg"
    tar --checkpoint=10000 -czf build/shared/tools/MovieMaker/ffmpeg-5.0.1.gz ${ffmpeg}
    cd build
    ant build
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/share/
    cp -dpr build/linux/work $out/share/${pname}
    rmdir $out/share/${pname}/java
    ln -s ${jdk} $out/share/${pname}/java
    makeWrapper $out/share/${pname}/processing $out/bin/processing \
      ''${gappsWrapperArgs[@]} \
      --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd
    makeWrapper $out/share/${pname}/processing-java $out/bin/processing-java \
      ''${gappsWrapperArgs[@]} \
      --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd
  '';

  meta = with lib; {
    description = "A language and IDE for electronic arts";
    homepage = "https://processing.org";
    license = with licenses; [ gpl2Only lgpl21Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ evan-goode ];
  };
}
