{
  atk,
  autoPatchelfHook,
  cairo,
  copyDesktopItems,
  freetype,
  fontconfig,
  lib,
  stdenv,
  fetchurl,
  gtk2,
  glib,
  gdk-pixbuf,
  makeWrapper,
  makeDesktopItem,
  pango,
  unzip,
  xorg,
  zlib,
}:
stdenv.mkDerivation rec {

  pname = "mricron";
  version = "1.0.20190902";
  src = fetchurl {
    url = "https://github.com/neurolabusc/MRIcron/releases/download/v${version}/MRIcron_linux.zip";
    hash = "sha256-C155u9dvYEyWRfTv3KNQFI6aMWIAjgvdSIqMuYVIOQA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    unzip
  ];

  buildInputs = [
    atk
    cairo
    freetype
    fontconfig
    gtk2
    glib
    gdk-pixbuf
    pango
    xorg.libX11
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/256x256/apps

    install -Dm777 ./MRIcron $out/bin/mricron
    install -Dm444 -t $out/share/icons/hicolor/scalable/apps/ ./Resources/mricron.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "mricron";
      desktopName = "MRIcron";
      comment = "Application to display NIfTI medical imaging data";
      exec = "mricron %U";
      icon = "mricron";
      categories = [
        "Graphics"
        "MedicalSoftware"
        "Science"
      ];
      terminal = false;
      keywords = [
        "medical"
        "imaging"
        "nifti"
      ];
    })
  ];

  meta = with lib; {
    description = "Application to display NIfTI medical imaging data";
    homepage = "https://people.cas.sc.edu/rorden/mricron/index.HTML";
    license = licenses.bsd1;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ adriangl ];
    mainProgram = "mricron";
  };
}
