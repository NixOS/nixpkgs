{ stdenv, callPackage, fetchFromGitHub, makeWrapper, ant, jdk, rsync, javaPackages, libXxf86vm }:

stdenv.mkDerivation rec {
  version = "3.3.7";
  name = "processing3-${version}";

  src = fetchFromGitHub {
    owner = "processing";
    repo = "processing";
    rev = "processing-0264-3.3.7";
    sha256 = "0a20z19lmc4xarfnr7xshcmlv3xkc2dgjxknis0iv79gxnwlqhpq";
  };

  nativeBuildInputs = [ ant rsync makeWrapper ];
  buildInputs = [ jdk ];

  buildPhase = ''
    # use compiled jogl to avoid patchelf'ing .so files inside jars
    rm core/library/*.jar
    cp ${javaPackages.jogl_2_3_2}/share/java/*.jar core/library/

    # suppress "Not fond of this Java VM" message box
    substituteInPlace app/src/processing/app/platform/LinuxPlatform.java \
      --replace 'Messages.showWarning' 'if (false) Messages.showWarning'

    ( cd build
      substituteInPlace build.xml --replace "jre-download," ""  # do not download jre1.8.0_144
      mkdir -p linux/jre1.8.0_144                               # fake dir to avoid error
      ant build )
  '';

  installPhase = ''
    mkdir $out
    cp -dpR build/linux/work $out/${name}

    rmdir $out/${name}/java
    ln -s ${jdk} $out/${name}/java

    makeWrapper $out/${name}/processing      $out/bin/processing \
        --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd \
        --prefix LD_LIBRARY_PATH : ${libXxf86vm}/lib
    makeWrapper $out/${name}/processing-java $out/bin/processing-java \
        --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd \
        --prefix LD_LIBRARY_PATH : ${libXxf86vm}/lib
  '';

  meta = with stdenv.lib; {
    description = "A language and IDE for electronic arts";
    homepage = https://processing.org;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
