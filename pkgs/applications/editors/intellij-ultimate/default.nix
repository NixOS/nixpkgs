{ stdenv, lib, fetchurl, pkgs, makeWrapper, makeDesktopItem, jetbrains }:

stdenv.mkDerivation rec {
  name = "intellij-ultimate-${version}";
  version = "2017.3.4";
  src = fetchurl {
    url = "https://download-cf.jetbrains.com/idea/ideaIU-${version}-no-jdk.tar.gz";
    sha256 = "2931e45d3ee381a51415d9e95e8b42e76544119b33b94edb035b07f68d3e2339";
    name = "${name}.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontPatchELF = true;

  buildPhase = ":";   # nothing to build

  icon = fetchurl {
    url = "http://resources.jetbrains.com/storage/products/intellij-idea/img/meta/intellij-idea_logo_300x300.png";
    sha256 = "1rhgpmbggx8fsvfc2wj00crxlipi5cv3bnps522kdn0f53qyzh4y";
  };

  desktopItem = makeDesktopItem {
    name = "intellij-ultimate";
    exec = "intellij-ultimate";
    icon = "${icon}";
    comment = "IntelliJ Ultimate";
    desktopName = "IntelliJ Ultimate";
    genericName = "IntelliJ";
    categories = "Application;Development;";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/intellij-ultimate
    cp -R * $out/share/intellij-ultimate
    ln -s $out/share/intellij-ultimate/bin/idea.sh $out/bin/intellij-ultimate
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  preFixup = let
    libPath = lib.makeSearchPathOutput "" "" [
      jetbrains.jdk
    ];
  in ''
    wrapProgram $out/bin/intellij-ultimate --prefix JAVA_HOME : ${libPath}
  '';

  meta = with stdenv.lib; {
    homepage = https://www.jetbrains.com/idea;
    description = "The Java IDE for Professional Developers by JetBrains";
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ xurei ];
  };
}
