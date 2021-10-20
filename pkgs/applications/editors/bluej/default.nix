{ lib, stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  pname = "bluej";
  version = "5.0.2";
  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.bluej.org/download/files/BlueJ-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    sha256 = "sha256-9sWfVQF/wCiVDKBmesMpM+5BHjFUPszm6U1SgJNQ8lE=";
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
