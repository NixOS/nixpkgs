{ lib, stdenv, fetchFromGitHub, fetchurl, ant, unzip, makeWrapper, jdk11, javaPackages, rsync, ffmpeg, batik, gsettings-desktop-schemas, xorg, wrapGAppsHook }:
let
  vaqua = fetchurl {
    name = "VAqua9.jar";
    url = "https://violetlib.org/release/vaqua/9/VAqua9.jar";
    sha256 = "cd0b82df8e7434c902ec873364bf3e9a3e6bef8b59cbf42433130d71bf1a779c";
  };

  jna = fetchurl {
    name = "jna-5.8.0.zip";
    url = "https://github.com/java-native-access/jna/archive/5.8.0.zip";
    sha256 = "7cRkkxyo2Ld19Nif8oWceITt7dYMUnQlrs0R5e0AmPE=";
  };

  gluon = fetchurl {
    name = "javafx-16-sdk-linux.zip";
    url = "https://gluonhq.com/download/javafx-16-sdk-linux";
    sha256 = "W9Q5LQ0tak3cEr7fjZEtSvF/hiLwVg2+AoH1bE+e0Uw=";
  };

in
stdenv.mkDerivation rec {
  pname = "processing";
  version = "1276-4.0b1";

  src = fetchFromGitHub {
    owner = "processing";
    repo = "processing4";
    rev = "processing-${version}";
    sha256 = "9AUHT8lEkYQ+TcpHJ7D24QZf6DjTPmthd/oVg/+Pt2Q=";
  };

  nativeBuildInputs = [ ant unzip makeWrapper wrapGAppsHook ];
  buildInputs = [ jdk11 javaPackages.jogl_2_3_2 ant rsync ffmpeg batik ];

  dontWrapGApps = true;

  buildPhase = ''
    echo "tarring jdk"
    tar --checkpoint=10000 -czf build/linux/jdk-11.0.12.tgz ${jdk11}
    cp ${ant}/lib/ant/lib/{ant.jar,ant-launcher.jar} app/lib/
    mkdir -p core/library
    ln -s ${javaPackages.jogl_2_3_2}/share/java/* core/library/
    cp ${vaqua} app/lib/VAqua9.jar
    unzip -qo ${jna} -d app/lib/
    mv app/lib/{jna-5.8.0/dist/jna.jar,}
    mv app/lib/{jna-5.8.0/dist/jna-platform.jar,}
    GLUON="java/libraries/javafx/library"
    mkdir -p $GLUON/linux64/modules/
    mkdir -p $GLUON/macosx/modules/
    unzip -qo ${gluon} -d $GLUON/
    cp $GLUON/javafx-sdk-16/lib/*.jar $GLUON/macosx/modules/
    cp $GLUON/javafx-sdk-16/lib/*.so $GLUON/linux64/
    cp -r ${batik}/* java/libraries/svg/library/
    cp java/libraries/svg/library/{lib/,}batik-all-1.14.jar
    echo "tarring ffmpeg"
    tar --checkpoint=10000 -czf build/shared/tools/MovieMaker/ffmpeg-4.4.gz ${ffmpeg}
    sed -i 's/depends="download-javafx"//g' java/libraries/javafx/build.xml
    sed -i '888,889d' java/libraries/javafx/src/processing/javafx/PSurfaceFX.java
    cd build
    ant build
    cd ..
  '';

  installPhase = ''
    mkdir $out
    cp -dpr build/linux/work $out/${pname}
    rmdir $out/${pname}/java
    ln -s ${jdk11} $out/${pname}/java
    makeWrapper $out/${pname}/processing      $out/bin/processing \
      ''${gappsWrapperArgs[@]} \
      --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd
    makeWrapper $out/${pname}/processing-java $out/bin/processing-java \
      ''${gappsWrapperArgs[@]} \
      --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd
  '';

  meta = with lib; {
    description = "A language and IDE for electronic arts";
    homepage = "https://processing.org";
    license = with licenses; [ gpl2Only lgpl21Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ matyklug ];
  };
}
