{ lib, stdenv, fetchurl, openjdk, glib, dpkg, wrapGAppsHook3 }:

stdenv.mkDerivation rec {
  pname = "greenfoot";
  version = "3.8.2";

  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.greenfoot.org/download/files/Greenfoot-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    hash = "sha256-wpmgWtx2jTDjt+7p6HcjU/uy1PRmnAHpJ1rOYb+hV+U=";
  };

  nativeBuildInputs = [ dpkg wrapGAppsHook3 ];
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
    description = "Simple integrated development environment for Java";
    homepage = "https://www.greenfoot.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2ClasspathPlus;
    mainProgram = "greenfoot";
    maintainers = [ maintainers.chvp ];
    platforms = platforms.linux;
  };
}
