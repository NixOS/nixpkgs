{
  lib,
  stdenv,
  autoPatchelfHook,
  makeDesktopItem,
  makeWrapper,
  copyDesktopItems,
  fetchurl,
  # System libraries
  curl,
  libGL,
  libX11,
  libXext,
  libXmu,
  libXrandr,
  libXrender,
  # Runtime utilities
  coreutils,
  libredirect,
  gnugrep,
  util-linux,
  which,
  # Multimedia support
  glib,
  gst_all_1,
}:

let
  version = "2021";
  subVersion = "1054";
  fullVersion = "${version}-${subVersion}";

  # Common MIME types
  mimeTypes = {
    spreadsheet = [
      "application/x-pmd"
      "application/x-pmdx"
      "application/x-pmv"
      "application/excel"
      "application/x-excel"
      "application/x-ms-excel"
      "application/x-msexcel"
      "application/x-sylk"
      "application/x-xls"
      "application/xls"
      "application/vnd.ms-excel"
      "application/vnd.stardivision.calc"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
      "application/vnd.ms-excel.sheet.macroenabled.12"
      "application/vnd.ms-excel.template.macroEnabled.12"
      "application/x-dif"
      "text/spreadsheet"
      "text/csv"
      "application/x-prn"
      "application/vnd.ms-excel.sheet.binary.macroenabled.12"
    ];

    presentation = [
      "application/x-prdx"
      "application/x-prvx"
      "application/x-prsx"
      "application/x-prd"
      "application/x-prv"
      "application/x-prs"
      "application/ppt"
      "application/mspowerpoint"
      "application/vnd.ms-powerpoint"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/vnd.ms-powerpoint.presentation.macroenabled.12"
      "application/vnd.openxmlformats-officedocument.presentationml.template"
      "application/vnd.ms-powerpoint.template.macroEnabled.12"
      "application/vnd.ms-powerpoint.slideshow.macroenabled.12"
      "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
    ];

    document = [
      "application/x-tmdx"
      "application/x-tmvx"
      "application/x-tmd"
      "application/x-tmv"
      "application/msword"
      "application/vnd.ms-word"
      "application/x-doc"
      "text/rtf"
      "application/rtf"
      "application/vnd.oasis.opendocument.text"
      "application/vnd.oasis.opendocument.text-template"
      "application/vnd.stardivision.writer"
      "application/vnd.sun.xml.writer"
      "application/vnd.sun.xml.writer.template"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.ms-word.document.macroenabled.12"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
      "application/vnd.ms-word.template.macroenabled.12"
      "application/x-pocket-word"
      "application/x-dbf"
      "application/msword-template"
    ];
  };

  # Helper function for creating desktop items
  makeOfficeDesktopItem =
    {
      name,
      desktopName,
      icon,
      mimeTypeList,
      startupWMClass,
    }:
    makeDesktopItem {
      name = "softmaker-freeoffice-${name}";
      desktopName = "FreeOffice ${desktopName}";
      icon = "softmaker-freeoffice-${icon}";
      categories = [ "Office" ];
      exec = "softmaker-freeoffice-${name} %F";
      tryExec = "softmaker-freeoffice-${name}";
      mimeTypes = mimeTypeList;
      inherit startupWMClass;
    };

  # Desktop items configuration
  appDesktopItems = {
    planmaker = makeOfficeDesktopItem {
      name = "planmaker";
      desktopName = "PlanMaker";
      icon = "pml";
      mimeTypeList = mimeTypes.spreadsheet;
      startupWMClass = "pm";
    };

    presentations = makeOfficeDesktopItem {
      name = "presentations";
      desktopName = "Presentations";
      icon = "prl";
      mimeTypeList = mimeTypes.presentation;
      startupWMClass = "pr";
    };

    textmaker = makeOfficeDesktopItem {
      name = "textmaker";
      desktopName = "TextMaker";
      icon = "tml";
      mimeTypeList = mimeTypes.document;
      startupWMClass = "tm";
    };
  };

  runtimePath = lib.makeBinPath [
    coreutils
    gnugrep
    util-linux
    which
  ];

in
stdenv.mkDerivation rec {
  pname = "softmaker-freeoffice";
  version = fullVersion;

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
    hash = "sha256-dqmJUm0Qi1/GzGrI4OCHo1LwQ5KxMwZZw5EsYTMF6XU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    # System libraries
    curl
    libGL
    libX11
    libXext
    libXmu
    libXrandr
    libXrender
    (lib.getLib stdenv.cc.cc)
    # Multimedia support
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack
    mkdir installer
    tar -C installer -xf $src
    mkdir ${pname}
    tar -C ${pname} -xf installer/freeoffice2021.tar.lzma
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r ${pname} $out/share/${pname}

    # Create wrapped binaries
    mkdir -p $out/bin
    for app in planmaker presentations textmaker; do
      makeWrapper $out/share/${pname}/$app $out/bin/${pname}-$app \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS "/bin/ls=${coreutils}/bin/ls" \
        --prefix PATH : "${runtimePath}"
    done

    # Install icons
    for size in 16 32 48 64 96 128 256 512 1024; do
      mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
      mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/mimetypes"

      # Application icons
      for app in pml prl tml; do
        ln -s "$out/share/${pname}/icons/''${app}_$size.png" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/${pname}-$app.png"
      done

      # Mimetype icons
      for mimetype in pmd prd tmd; do
        ln -s "$out/share/${pname}/icons/''${mimetype}_$size.png" \
          "$out/share/icons/hicolor/''${size}x''${size}/mimetypes/application-x-$mimetype.png"
      done
    done

    # Remove broken symbolic links
    find $out -xtype l -ls -exec rm {} \;

    # Install mime types
    install -D -t $out/share/mime/packages ${pname}/mime/softmaker-freeoffice*.xml

    runHook postInstall
  '';

  desktopItems = builtins.attrValues appDesktopItems;

  meta = {
    description = "Free office suite with a word processor, spreadsheet and presentation program";
    longDescription = ''
      SoftMaker FreeOffice is a free office suite that includes:
      - TextMaker for word processing
      - PlanMaker for spreadsheets
      - Presentations for creating presentations
      While it's free of charge, it maintains good compatibility with Microsoft Office formats.
    '';
    homepage = "https://www.freeoffice.com/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.liberodark ];
  };
}
