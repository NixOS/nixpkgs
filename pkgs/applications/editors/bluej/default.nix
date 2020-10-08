{ stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  pname = "bluej";
  version = "4.2.2";
  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.bluej.org/download/files/BlueJ-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    sha256 = "5c2241f2208e98fcf9aad7c7a282bcf16e6fd543faa5fdb0b99b34d1023113c3";
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

  meta = with stdenv.lib; {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    license = licenses.gpl2ClasspathPlus;
    maintainers = [ maintainers.charvp ];
    platforms = platforms.unix;
  };
}
