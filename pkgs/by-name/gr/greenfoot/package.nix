{
  lib,
  stdenv,
  fetchurl,
  openjdk21,
  openjfx21,
  glib,
  dpkg,
  wrapGAppsHook3,
}:
let
  openjdk = openjdk21.override {
    enableJavaFX = true;
    openjfx_jdk = openjfx21.override { withWebKit = true; };
  };
in
stdenv.mkDerivation rec {
  pname = "greenfoot";
  version = "3.9.0";

  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.greenfoot.org/download/files/Greenfoot-linux-arm64-${
      builtins.replaceStrings [ "." ] [ "" ] version
    }.deb";
    hash = "sha256-d5bkK+teTA4fxFb46ovbZE28l8WILGStv3Vg3nJZfv0=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
  ];
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
      --add-flags "-Dawt.useSystemAAFontSettings=gasp -Xmx512M \
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
    license = with licenses; [
      gpl2Plus
      classpathException20
    ];
    mainProgram = "greenfoot";
    maintainers = [ maintainers.chvp ];
    platforms = platforms.linux;
  };
}
