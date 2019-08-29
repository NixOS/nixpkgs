{ stdenv, fetchFromGitHub, fetchurl, xmlstarlet, makeWrapper, ant, jdk, rsync, javaPackages, libXxf86vm, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "processing";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "processing";
    repo = "processing";
    rev = "processing-0269-${version}";
    sha256 = "0ajniy3a0i0rx7is46r85yh3ah4zm4ra1gbllmihw9pmnfjgfajn";
  };

  nativeBuildInputs = [ ant rsync makeWrapper ];
  buildInputs = [ jdk ];

  buildPhase = ''
    # use compiled jogl to avoid patchelf'ing .so files inside jars
    rm core/library/*.jar
    cp ${javaPackages.jogl_2_3_2}/share/java/*.jar core/library/

    # do not download a file during build
    ${xmlstarlet}/bin/xmlstarlet ed --inplace -P -d '//get[@src="http://download.processing.org/reference.zip"]' build/build.xml
    install -D -m0444 ${fetchurl {
                          url    = http://download.processing.org/reference.zip;
                          sha256 = "198bpk8mzns6w5h0zdf50wr6iv7sgdi6v7jznj5rbsnpgyilxz35";
                        }
                       } ./java/reference.zip

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
    cp -dpR build/linux/work $out/${pname}

    rmdir $out/${pname}/java
    ln -s ${jdk} $out/${pname}/java

    makeWrapper $out/${pname}/processing      $out/bin/processing \
        --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
        --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd \
        --prefix LD_LIBRARY_PATH : ${libXxf86vm}/lib
    makeWrapper $out/${pname}/processing-java $out/bin/processing-java \
        --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
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
