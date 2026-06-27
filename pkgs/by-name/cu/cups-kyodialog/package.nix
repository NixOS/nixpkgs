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

stdenv.mkDerivation (finalAttrs: {
  pname = "cups-kyodialog";
  version = "${finalAttrs.kyodialog_version}-${finalAttrs.date}";

  kyodialog_version = "10.0";
  date = "20240521";

  dontStrip = true;

  src = fetchzip {
    # Steps to find the release download URL:
    # 1. Go to https://www.kyoceradocumentsolutions.us/en/support/downloads.html
    # 2. Search for printer model, e.g. "TASKalfa 6053ci"
    # 3. Locate e.g. "Linux Print Driver (9.3)" in the list
    urls = [
      "https://www.kyoceradocumentsolutions.us/content/dam/download-center-americas-cf/us/drivers/drivers/KyoceraLinuxPackages_${finalAttrs.date}_tar_gz.download.gz"
      "https://web.archive.org/web/20260601160308/https://www.kyoceradocumentsolutions.us/content/dam/download-center-americas-cf/us/drivers/drivers/KyoceraLinuxPackages_${finalAttrs.date}_tar_gz.download.gz"
    ];
    hash = "sha256-7oiw4vmhITdYIylOMCkmK4WBLHCxdcA4NAwvswCcJWg=";
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
      ar p "$src/Debian/${region}/kyodialog_${platform}/kyodialog_${finalAttrs.kyodialog_version}-0_${platform}.deb" data.tar.gz | tar -xz
    '';

  nativeBuildInputs = [
    autoPatchelfHook
    python3Packages.wrapPython
  ]
  ++ lib.optionals withQtGui [ qt5.wrapQtAppsHook ];

  buildInputs = [ cups ] ++ lib.optionals withQtGui [ qt5.qtbase ];

  # For lib/cups/filter/kyofilter_pre_H.
  # The source already contains a copy of pypdf3, but we use the Nix package
  propagatedBuildInputs = with python3Packages; [
    reportlab
    pypdf3
    setuptools
  ];

  installPhase = ''
    # allow cups to find the ppd files
    mkdir -p $out/share/cups/model
    mv ./usr/share/kyocera${finalAttrs.kyodialog_version}/ppd${finalAttrs.kyodialog_version} $out/share/cups/model/Kyocera

    # remove absolute path prefixes to filters in ppd
    find $out -name "*.ppd" -exec sed -E -i "s:/usr/lib/cups/filter/::g" {} \;


    mkdir -p $out/lib/cups/
    mv ./usr/lib/cups/filter/ $out/lib/cups/
    # for lib/cups/filter/kyofilter_pre_H
    wrapPythonProgramsIn $out/lib/cups/filter "$propagatedBuildInputs"


    install -Dm444 usr/share/doc/kyodialog/copyright $out/share/doc/${finalAttrs.pname}/copyright
  ''
  + lib.optionalString withQtGui ''
    install -D usr/bin/kyoPPDWrite_H $out/bin/kyoPPDWrite_H
    install -D usr/bin/kyodialog${finalAttrs.kyodialog_version} $out/bin/kyodialog

    install -Dm444 usr/share/kyocera${finalAttrs.kyodialog_version}/appicon_H.png $out/share/${finalAttrs.pname}/icons/appicon_H.png

    install -Dm444 usr/share/applications/kyodialog${finalAttrs.kyodialog_version}.desktop $out/share/applications/kyodialog.desktop
    substituteInPlace $out/share/applications/kyodialog.desktop \
      --replace Exec=\"/usr/bin/kyodialog${finalAttrs.kyodialog_version}\" Exec=\"$out/bin/kyodialog\" \
      --replace Icon=/usr/share/kyocera/appicon_H.png Icon=$out/share/${finalAttrs.pname}/icons/appicon_H.png
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
})
