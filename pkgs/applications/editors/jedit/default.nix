{ stdenv, fetchurl, ant, jdk }:

let version = "4.4.2"; in

stdenv.mkDerivation {
  name = "jedit-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/jedit/jedit${version}source.tar.bz2";
    sha256 = "5e9ad9c32871b77ef0b9fe46dcfcea57ec52558d36113b7280194a33430b8ceb";
  };

  buildInputs = [ ant jdk ];

  sourceRoot = "jEdit";

  buildPhase = "ant build";

  installPhase = ''
    mkdir -p $out/share/jEdit
    cp build/jedit.jar $out/share/jEdit
    mkdir -p $out/share/jEdit/modes
    cp -r modes/* $out/share/jEdit/modes
    mkdir -p $out/share/jEdit/icons
    cp -r icons/* $out/share/jEdit/icons
    mkdir -p $out/share/jEdit/macros
    cp -r macros/* $out/share/jEdit/macros
    mkdir -p $out/share/jEdit/doc
    cp -r doc/* $out/share/jEdit/doc

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

  meta = {
    description = "Mature programmer's text editor (Java based)";
    homepage = http://www.jedit.org;
    license = "GPL";
  };
}
