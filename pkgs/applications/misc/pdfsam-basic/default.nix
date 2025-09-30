{
  lib,
  stdenv,
  makeDesktopItem,
  fetchurl,
  jdk21,
  wrapGAppsHook3,
  glib,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "pdfsam-basic";
  version = "5.3.2";

  src = fetchurl {
    url = "https://github.com/torakiki/pdfsam/releases/download/v${version}/pdfsam-basic_${version}-1_amd64.deb";
    hash = "sha256-Y0Q9uT6cyxIYTX0JxoS0r3TamPT1iLXr94Zex30AeWo=";
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/torakiki/pdfsam";
    description = "Multi-platform software designed to extract pages, split, merge, mix and rotate PDF files";
    mainProgram = "pdfsam-basic";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ _1000101 ];
  };
}
