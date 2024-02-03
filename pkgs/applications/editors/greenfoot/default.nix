{ lib, stdenv, fetchurl, openjdk, glib, dpkg, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "greenfoot";
  version = "3.8.0";

  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.greenfoot.org/download/files/Greenfoot-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    sha256 = "sha256-HDXmgLHS18VZVV+hCA0RgIrKRftOlV7t+fvE0pAHGjk=";
  };

  nativeBuildInputs = [ dpkg wrapGAppsHook ];
  buildInputs = [ glib ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out

    rm -r $out/share/greenfoot/jdk
    rm -r $out/share/greenfoot/javafx-*.jar

    makeWrapper ${openjdk}/bin/java $out/bin/greenfoot \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Dawt.useSystemAAFontSettings=on -Xmx512M \
                   --add-opens javafx.graphics/com.sun.glass.ui=ALL-UNNAMED \
                   -cp $out/share/greenfoot/boot.jar bluej.Boot \
                   -greenfoot=true -bluej.compiler.showunchecked=false \
                   -greenfoot.scenarios=$out/share/doc/Greenfoot/scenarios \
                   -greenfoot.url.javadoc=file://$out/share/doc/Greenfoot/API"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.greenfoot.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2ClasspathPlus;
    mainProgram = pname;
    maintainers = [ maintainers.chvp ];
    platforms = platforms.linux;
  };
}
