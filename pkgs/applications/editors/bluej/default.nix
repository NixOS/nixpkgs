{ lib, stdenv, fetchurl, openjdk, glib, dpkg, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "bluej";
  version = "5.2.0";

  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.bluej.org/download/files/BlueJ-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    sha256 = "sha256-sOT86opMa9ytxJlfURIsD06HiP+j+oz3lQ0DqmLV1wE=";
  };

  nativeBuildInputs = [ dpkg wrapGAppsHook ];
  buildInputs = [ glib ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out

    rm -r $out/share/bluej/jdk
    rm -r $out/share/bluej/javafx
    rm -r $out/share/bluej/javafx-*.jar

    makeWrapper ${openjdk}/bin/java $out/bin/bluej \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Dawt.useSystemAAFontSettings=on -Xmx512M \
                   --add-opens javafx.graphics/com.sun.glass.ui=ALL-UNNAMED \
                   -cp $out/share/bluej/boot.jar bluej.Boot"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2ClasspathPlus;
    mainProgram = pname;
    maintainers = with maintainers; [ chvp ];
    platforms = platforms.linux;
  };
}
