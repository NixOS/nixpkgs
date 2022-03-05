{ lib
, stdenv
, fetchurl
, glib
, jre
, unzip
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, wrapGAppsHook
}:

let
  icon = fetchurl {
    url = "https://imagej.net/media/icons/imagej.png";
    sha256 = "sha256-nU2nWI1wxZB/xlOKsZzdUjj+qiCTjO6GwEKYgZ5Risg=";
  };
in stdenv.mkDerivation rec {
  pname = "imagej";
  version = "153";

  src = fetchurl {
    url = "https://wsr.imagej.net/distros/cross-platform/ij${version}.zip";
    sha256 = "sha256-MGuUdUDuW3s/yGC68rHr6xxzmYScUjdXRawDpc1UQqw=";
  };
  nativeBuildInputs = [ copyDesktopItems makeWrapper unzip wrapGAppsHook ];
  buildInputs = [ glib ];
  dontWrapGApps = true;

  desktopItems = lib.optionals stdenv.isLinux [
    (makeDesktopItem {
      name = "ImageJ";
      desktopName = "ImageJ";
      icon = "imagej";
      categories = [ "Science" "Utility" "Graphics" ];
      exec = "imagej";
    })
  ];

  passthru = {
    inherit jre;
  };

  # JAR files that are intended to be used by other packages
  # should go to $out/share/java.
  # (Some uses ij.jar as a library not as a standalone program.)
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java $out/bin
    # Read permisssion suffices for the jar and others.
    # Simple cp shall clear suid bits, if any.
    cp ij.jar $out/share/java
    cp -dR luts macros plugins $out/share

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    makeWrapper ${jre}/bin/java $out/bin/imagej \
      ''${gappsWrapperArgs[@]} \
      --add-flags "-jar $out/share/java/ij.jar -ijpath $out/share"

    install -Dm644 ${icon} $out/share/icons/hicolor/128x128/apps/imagej.png
    substituteInPlace $out/share/applications/ImageJ.desktop \
      --replace Exec=imagej Exec=$out/bin/imagej
  '';

  meta = with lib; {
    homepage = "https://imagej.nih.gov/ij/";
    description = "Image processing and analysis in Java";
    longDescription = ''
      ImageJ is a public domain Java image processing program
      inspired by NIH Image for the Macintosh.
      It runs on any computer with a Java 1.4 or later virtual machine.
    '';
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yuriaisaka ];
  };
}
