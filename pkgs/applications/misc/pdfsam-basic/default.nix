{ stdenv, makeDesktopItem, fetchurl, jdk11, wrapGAppsHook, glib }:

stdenv.mkDerivation rec {
  pname = "pdfsam-basic";
  version = "4.0.5";

  src = fetchurl {
    url = "https://github.com/torakiki/pdfsam/releases/download/v${version}/pdfsam_${version}-1_amd64.deb";
    sha256 = "1znadsg65312h8yyxvj8k0c4pl3g9daif50vk50acwpblq49wm1v";
  };

  unpackPhase = ''
    ar vx ${src}
    tar xvf data.tar.gz
  '';

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ glib ];

  preFixup = ''
    gappsWrapperArgs+=(--set JAVA_HOME "${jdk11}" --set PDFSAM_JAVA_PATH "${jdk11}")
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
    mimeType = "application/pdf;";
    categories = "Office;Application;";
  };

  meta = with stdenv.lib; {
      homepage = "https://github.com/torakiki/pdfsam";
      description = "Multi-platform software designed to extract pages, split, merge, mix and rotate PDF files";
      license = licenses.agpl3;
      platforms = platforms.all;
      maintainers = with maintainers; [ maintainers."1000101" ];
  };
}