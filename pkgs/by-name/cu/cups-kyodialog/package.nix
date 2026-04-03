{
  lib,
  stdenv,
  fetchzip,
  cups,
  autoPatchelfHook,
  python3Packages,

  # Sets the default paper format: use "EU" for A4, or "Global" for Letter
  region ? "EU",
  # optional GUI, quite redundant to CUPS admin web GUI
  withQtGui ? false,
  qt5,
}:

# Open issues:
#
# Printing in grayscale mode (e.g. the test page) generates a warning
# > [Job 59] Grayscale/monochrome printing requested for this job but Poppler is not able to convert to grayscale/monochrome PostScript.
# > [Job 59] Use \"pdftops-renderer\" option (see cups-filters README file) to use Ghostscript or MuPDF for the PDF -> PostScript conversion.
#
# This is related to https://github.com/OpenPrinting/cups-filters/issues/169.

assert region == "Global" || region == "EU";

let
  kyodialog_version = "9.4";
  date = "20240521";
in
stdenv.mkDerivation rec {
  pname = "cups-kyodialog";
  version = "${kyodialog_version}-${date}";

  dontStrip = true;

  src = fetchzip {
    # Steps to find the release download URL:
    # 1. Go to https://www.kyoceradocumentsolutions.us/en/support/downloads.html
    # 2. Search for printer model, e.g. "TASKalfa 6053ci"
    # 3. Locate e.g. "Linux Print Driver (9.3)" in the list
    urls = [
      "https://www.kyoceradocumentsolutions.us/content/download-center-americas/us/drivers/drivers/KyoceraLinuxPackages_${date}_tar_gz.download.gz"
      "https://web.archive.org/web/20260107200228/https://www.kyoceradocumentsolutions.us/content/download-center-americas/us/drivers/drivers/KyoceraLinuxPackages_${date}_tar_gz.download.gz"
    ];
    hash = "sha256-H9n4KpaLGNk5du4+BAmMjRyLmXaHap8HdNZlX/Kia4E=";
    extension = "tar.gz";
    stripRoot = false;
    postFetch = ''
      # delete redundant Linux package dirs to reduce size in the Nix store; only keep Debian
      rm -r $out/{CentOS,Fedora,OpenSUSE,Redhat,Ubuntu}
    '';
  };

  sourceRoot = ".";

  unpackCmd =
    let
      platforms = {
        x86_64-linux = "amd64";
        i686-linux = "i386";
      };
      platform =
        platforms.${stdenv.hostPlatform.system}
          or (throw "unsupported system: ${stdenv.hostPlatform.system}");
    in
    ''
      ar p "$src/Debian/${region}/kyodialog_${platform}/kyodialog_${kyodialog_version}-0_${platform}.deb" data.tar.gz | tar -xz
    '';

  nativeBuildInputs = [
    autoPatchelfHook
    python3Packages.wrapPython
  ]
  ++ lib.optionals withQtGui [ qt5.wrapQtAppsHook ];

  buildInputs = [ cups ] ++ lib.optionals withQtGui [ qt5.qtbase ];

  # For lib/cups/filter/kyofilter_pre_H.
  # The source already contains a copy of pypdf3, but we use the maintained
  # Nix package instead and patch the legacy filter import accordingly.
  propagatedBuildInputs = with python3Packages; [
    reportlab
    pypdf
    setuptools
  ];

  installPhase = ''
    # allow cups to find the ppd files
    mkdir -p $out/share/cups/model
    mv ./usr/share/kyocera${kyodialog_version}/ppd${kyodialog_version} $out/share/cups/model/Kyocera

    # remove absolute path prefixes to filters in ppd
    find $out -name "*.ppd" -exec sed -E -i "s:/usr/lib/cups/filter/::g" {} \;


    mkdir -p $out/lib/cups/
    mv ./usr/lib/cups/filter/ $out/lib/cups/
    substituteInPlace $out/lib/cups/filter/kyofilter_pre_H \
      --replace-fail 'from PyPDF3 import PdfFileWriter, PdfFileReader' 'from pypdf import PdfWriter, PdfReader' \
      --replace-fail 'CONFIG_DIR = "/usr/share/kyocera/"' 'CONFIG_DIR = "'"$out"'/share/kyocera/"' \
      --replace-fail 'PdfFileReader' 'PdfReader' \
      --replace-fail 'PdfFileWriter()' 'PdfWriter()' \
      --replace-fail 'base_pdf.getNumPages()' 'len(base_pdf.pages)' \
      --replace-fail 'watermark_pdf.getPage(0)' 'watermark_pdf.pages[0]' \
      --replace-fail 'base_pdf.getPage(p)' 'base_pdf.pages[p]' \
      --replace-fail 'page.mergePage(watermark)' 'page.merge_page(watermark)' \
      --replace-fail 'new_pdf.addPage(page)' 'new_pdf.add_page(page)'
    # for lib/cups/filter/kyofilter_pre_H
    wrapPythonProgramsIn $out/lib/cups/filter "$propagatedBuildInputs"


    install -Dm444 usr/share/doc/kyodialog/copyright $out/share/doc/${pname}/copyright
  ''
  + lib.optionalString withQtGui ''
    install -D usr/bin/kyoPPDWrite_H $out/bin/kyoPPDWrite_H
    install -D usr/bin/kyodialog${kyodialog_version} $out/bin/kyodialog

    install -Dm444 usr/share/kyocera${kyodialog_version}/appicon_H.png $out/share/${pname}/icons/appicon_H.png

    install -Dm444 usr/share/applications/kyodialog${kyodialog_version}.desktop $out/share/applications/kyodialog.desktop
    substituteInPlace $out/share/applications/kyodialog.desktop \
      --replace Exec=\"/usr/bin/kyodialog${kyodialog_version}\" Exec=\"$out/bin/kyodialog\" \
      --replace Icon=/usr/share/kyocera/appicon_H.png Icon=$out/share/${pname}/icons/appicon_H.png
  '';

  meta = {
    description = "CUPS drivers for several Kyocera printers";
    homepage = "https://www.kyoceradocumentsolutions.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.steveej ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
