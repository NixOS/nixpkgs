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
  pname = "bluej";
  version = "5.5.0";

  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://github.com/k-pet-group/BlueJ-Greenfoot/releases/download/BLUEJ-RELEASE-${version}/BlueJ-linux-x64-${version}.deb";
    sha256 = "sha256-wGAwGvMHBb0jHq83ZV6wGYzjvcqqIoOTwJYiAD9aSgI=";
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

    rm -r $out/share/bluej/jdk
    rm -r $out/share/bluej/javafx-*.jar

    makeWrapper ${openjdk}/bin/java $out/bin/bluej \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Dawt.useSystemAAFontSettings=gasp -Xmx512M \
                   --add-opens javafx.graphics/com.sun.glass.ui=ALL-UNNAMED \
                   -cp $out/share/bluej/boot.jar bluej.Boot"

    runHook postInstall
  '';

  meta = {
    description = "Simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = with lib.licenses; [
      gpl2Plus
      classpathException20
    ];
    mainProgram = "bluej";
    maintainers = with lib.maintainers; [ chvp ];
    platforms = lib.platforms.linux;
  };

}
