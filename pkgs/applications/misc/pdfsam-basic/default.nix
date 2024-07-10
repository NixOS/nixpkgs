{ lib, stdenv, makeDesktopItem, fetchurl, jdk21, wrapGAppsHook3, glib }:

stdenv.mkDerivation rec {
  pname = "pdfsam-basic";
  version = "5.2.3";

  src = fetchurl {
    url = "https://github.com/torakiki/pdfsam/releases/download/v${version}/pdfsam_${version}-1_amd64.deb";
    hash = "sha256-ai1UHMeLvCba6WV6f6dGc53CxPP7bJaPgo8Tm7ddkOM=";
  };

  unpackPhase = ''
    ar vx ${src}
    tar xvf data.tar.gz
  '';

  nativeBuildInputs = [ wrapGAppsHook3 ];
  buildInputs = [ glib ];

  preFixup = ''
    gappsWrapperArgs+=(--set JAVA_HOME "${jdk21}" --set PDFSAM_JAVA_PATH "${jdk21}")
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
    mainProgram = "pdfsam-basic";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _1000101 ];
  };
}
