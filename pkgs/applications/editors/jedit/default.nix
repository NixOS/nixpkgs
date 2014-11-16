{stdenv, fetchurl, ant, jdk, commonsBsf, commonsLogging}:

let
  version = "5.1.0";
  bsh = fetchurl {
    url = http://www.beanshell.org/bsh-2.0b4.jar;
    sha256 = "1di7hj2yms1m3wa8k70jpw0wzfnrgibpqnvdk33ahfaqi03mqfci";
  };
  bcpg = fetchurl {
    url = http://central.maven.org/maven2/org/bouncycastle/bcpg-jdk16/1.46/bcpg-jdk16-1.46.jar;
    sha256 = "16xhmwks4l65m5x150nd23y5lyppha9sa5fj65rzhxw66gbli82d";
  };
  jsr305 = fetchurl {
    url = http://central.maven.org/maven2/com/google/code/findbugs/jsr305/2.0.0/jsr305-2.0.0.jar;
    sha256 = "0s74pv8qjc42c7q8nbc0c3b1hgx0bmk3b8vbk1z80p4bbgx56zqy";
  };
in

stdenv.mkDerivation {
  name = "jedit-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/jedit/jedit${version}source.tar.bz2";
    sha256 = "015rn4339mp4wrd901x56nr42wfcy429pg54n835c6n34b2jjdc6";
  };

  buildInputs = [ ant jdk commonsBsf commonsLogging ];

  # This patch removes from the build process:
  #  - the automatic download of dependencies (see configurePhase);
  #  - the tests
  patches = [ ./build.xml.patch ];

  configurePhase = ''
    mkdir -p lib/ant-contrib/ lib/scripting lib/compile lib/default-plugins
    cp ${ant}/lib/ant/lib/ant-contrib-*.jar lib/ant-contrib/
    cp ${bsh} ${bcpg} lib/scripting/
    cp ${jsr305} lib/compile/
  '';

  buildPhase = "ant build";

  installPhase = ''
    mkdir -p $out/share/jEdit
    cp -r build/jedit.jar doc icons keymaps macros modes startup $out/share/jEdit

    sed -i "s|Icon=.*|Icon=$out/share/jEdit/icons/jedit-icon48.png|g" package-files/linux/deb/jedit.desktop
    mkdir -p $out/share/applications
    mv package-files/linux/deb/jedit.desktop $out/share/applications/jedit.desktop

    patch package-files/linux/jedit << EOF
    5a6,8
    > # specify the correct JAVA_HOME
    > JAVA_HOME=${jdk.jre}/lib/openjdk/jre
    > 
    EOF
    sed -i "s|/usr/share/jEdit/@jar.filename@|$out/share/jEdit/jedit.jar|g" package-files/linux/jedit
    mkdir -p $out/bin
    cp package-files/linux/jedit $out/bin/jedit
    chmod +x $out/bin/jedit
  '';

  meta = with stdenv.lib; {
    description = "Mature programmer's text editor (Java based)";
    homepage = http://www.jedit.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.vbgl ];
  };
}
