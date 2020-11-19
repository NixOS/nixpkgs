{ stdenv, fetchFromGitHub, fetchurl, xmlstarlet, makeWrapper, ant, jdk, rsync, javaPackages, libXxf86vm, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "processing";
  version = "3.5.4";

  src = fetchFromGitHub {
    owner = "processing";
    repo = "processing";
    rev = "processing-0270-${version}";
    sha256 = "0cvv8jda9y8qnfcsziasyv3w7h3w22q78ihr23cm4an63ghxci58";
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
                          # Use archive.org link for reproducibility until the following issue is fixed:
                          # https://github.com/processing/processing/issues/5711
                          url = "https://web.archive.org/web/20200406132357/https://download.processing.org/reference.zip";
                          sha256 = "093hc7kc9wfxqgf5dzfmfp68pbsy8x647cj0a25vgjm1swi61zbi";
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
    homepage = "https://processing.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
