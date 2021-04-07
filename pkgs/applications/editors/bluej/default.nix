{ lib, stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  pname = "bluej";
  version = "5.0.0";
  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.bluej.org/download/files/BlueJ-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    sha256 = "sha256-U81FIf67Qm/86+hA9iUCHt61dxiZsTkkequlVjft6/0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    ar xf $src
    tar xf data.tar.xz
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out

    makeWrapper ${jdk}/bin/java $out/bin/bluej \
      --add-flags "-Djavafx.embed.singleThread=true -Dawt.useSystemAAFontSettings=on -Xmx512M -cp \"$out/share/bluej/bluej.jar\" bluej.Boot"
  '';

  meta = with lib; {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    license = licenses.gpl2ClasspathPlus;
    maintainers = [ maintainers.chvp ];
    platforms = platforms.unix;
  };
}
