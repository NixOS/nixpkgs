{ lib, stdenv, fetchurl, openjdk, glib, wrapGAppsHook, dpkg }:

stdenv.mkDerivation rec {
  pname = "bluej";
  version = "5.1.0";

  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.bluej.org/download/files/BlueJ-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    sha256 = "sha256-tOb15wU9OjUt0D8l/JkaGYj84L7HV4FUnQQB5cRAxG0=";
  };

  nativeBuildInputs = [ wrapGAppsHook dpkg ];
  buildInputs = [ glib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out

    makeWrapper ${openjdk}/bin/java $out/bin/bluej \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Dawt.useSystemAAFontSettings=on -Xmx512M \
                   --add-opens javafx.graphics/com.sun.glass.ui=ALL-UNNAMED \
                   -jar $out/share/bluej/bluej.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2ClasspathPlus;
    maintainers = with maintainers; [ chvp ];
    platforms = platforms.linux;
  };
}
