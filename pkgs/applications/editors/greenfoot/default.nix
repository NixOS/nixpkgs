{ lib, stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  pname = "greenfoot";
  version = "3.7.0";
  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.greenfoot.org/download/files/Greenfoot-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    sha256 = "sha256-K9faU3ZarcR4g8riHpoZYVH0sXtueqfm3Fo+sZAHJA8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    ar xf $src
    tar xf data.tar.xz
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out
    rm -r $out/share/greenfoot/jdk
    rm -r $out/share/greenfoot/javafx

    makeWrapper ${jdk}/bin/java $out/bin/greenfoot \
      --add-flags "-Djavafx.embed.singleThread=true -Dawt.useSystemAAFontSettings=on -Xmx512M -cp \"$out/share/greenfoot/bluej.jar\" bluej.Boot -greenfoot=true -bluej.compiler.showunchecked=false -greenfoot.scenarios=$out/share/doc/Greenfoot/scenarios -greenfoot.url.javadoc=file://$out/share/doc/Greenfoot/API"
  '';

  meta = with lib; {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.greenfoot.org/";
    license = licenses.gpl2ClasspathPlus;
    maintainers = [ maintainers.chvp ];
    platforms = platforms.unix;
  };
}
