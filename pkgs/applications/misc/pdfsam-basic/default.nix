{ lib, stdenv, makeDesktopItem, fetchurl, jdk19, wrapGAppsHook, glib }:

stdenv.mkDerivation rec {
  pname = "pdfsam-basic";
  version = "5.0.3";

  src = fetchurl {
    url = "https://github.com/torakiki/pdfsam/releases/download/v${version}/pdfsam_${version}-1_amd64.deb";
    hash = "sha256-NST5d5dzO26ifKStbgD7qNbumUMQhfUFNE472LR1z5k=";
  };

  unpackPhase = ''
    ar vx ${src}
    tar xvf data.tar.gz
  '';

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ glib ];

  preFixup = ''
    gappsWrapperArgs+=(--set JAVA_HOME "${jdk19}" --set PDFSAM_JAVA_PATH "${jdk19}")
  '';

  installPhase = ''
    cp -R opt/pdfsam-basic/ $out/
    mkdir -p "$out"/share/icons
    cp --recursive ${desktopItem}/share/applications $out/share
    cp $out/icon.svg "$out"/share/icons/pdfsam-basic.svg
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = meta.description;
    desktopName = "PDFsam Basic";
    genericName = "PDF Split and Merge";
    mimeTypes = [ "application/pdf" ];
    categories = [ "Office" ];
  };

  meta = with lib; {
    homepage = "https://github.com/torakiki/pdfsam";
    description = "Multi-platform software designed to extract pages, split, merge, mix and rotate PDF files";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _1000101 ];
  };
}
