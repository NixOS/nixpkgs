{ lib
, stdenv
, fetchurl
, cups
, autoPatchelfHook
, python3Packages

# Sets the default paper format: use "EU" for A4, or "Global" for Letter
, region ? "EU"
}:

assert region == "Global" || region == "EU";

let
  kyodialog_version_short = "9";
  kyodialog_version_long = "9.0";
  date = "20221003";
in
stdenv.mkDerivation rec {
  pname = "cups-kyocera-3500-4500";
  version = "${kyodialog_version_long}-${date}";

  dontStrip = true;

  src = fetchurl {
    # Steps to find the release download URL:
    # 1. Go to https://www.kyoceradocumentsolutions.us/en/support/downloads.html
    # 2. Search for printer model, e.g. "TASKalfa 6053ci"
    # 3. Locate e.g. "Linux Print Driver (9.3)" in the list
    #
    # Where there's no version encoded in the vendor URL, prefer a
    # web.archive.org URL.  That means that if the vendor updates the package
    # at this URL, the package won't suddenly stop building.
    urls = [
      "https://web.archive.org/web/20241123173620/https://www.kyoceradocumentsolutions.us/content/download-center-americas/us/drivers/drivers/MA_PA_4500ci_Linux_gz.download.gz"
      "https://www.kyoceradocumentsolutions.us/content/download-center-americas/us/drivers/drivers/MA_PA_4500ci_Linux_gz.download.gz"
    ];
    hash = "sha256-pqBtfKiQo/+cF8fG5vsEQvr8UdxjGsSShXI+6bun03c=";
    recursiveHash = true;
    downloadToTemp = true;
    postFetch = ''
      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      mv "$downloadedFile" "$TMPDIR/source.tar.gz.gz"
      gunzip "$TMPDIR/source.tar.gz.gz"
      unpackFile "$TMPDIR/source.tar.gz"
      chmod -R +w "$unpackDir"
      mv "$unpackDir" "$out"

      # delete redundant Linux package dirs to reduce size in the Nix store; only keep Debian
      rm -r $out/{CentOS,Fedora,OpenSUSE,Redhat,Ubuntu}
    '';
  };

  sourceRoot = ".";

  unpackCmd = let
    platforms = {
      x86_64-linux = "amd64";
      i686-linux = "i386";
    };
    platform = platforms.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");
  in ''
    ar p "$src/Debian/${region}/kyodialog_${platform}/kyodialog_${kyodialog_version_long}-0_${platform}.deb" data.tar.gz | tar -xz
  '';

  nativeBuildInputs = [ autoPatchelfHook python3Packages.wrapPython ];

  buildInputs = [ cups ];

  # For lib/cups/filter/kyofilter_pre_H.
  # The source already contains a copy of pypdf3, but we use the Nix package
  propagatedBuildInputs = with python3Packages; [ reportlab pypdf3 setuptools ];

  installPhase = ''
    # allow cups to find the ppd files
    mkdir -p $out/share/cups/model
    mv ./usr/share/kyocera${kyodialog_version_short}/ppd${kyodialog_version_short} $out/share/cups/model/Kyocera

    # remove absolute path prefixes to filters in ppd
    find $out -name "*.ppd" -exec sed -E -i "s:/usr/lib/cups/filter/::g" {} \;

    mkdir -p $out/lib/cups/
    mv ./usr/lib/cups/filter/ $out/lib/cups/
    # for lib/cups/filter/kyofilter_pre_H
    wrapPythonProgramsIn $out/lib/cups/filter "$propagatedBuildInputs"

    install -Dm444 usr/share/doc/kyodialog/copyright $out/share/doc/cups-kyocera-3500-4500/copyright
  '';

  meta = with lib; {
    description = "CUPS drivers for Kyocera ECOSYS MA3500cix, MA3500cifx, MA4000cix, MA4000cifx, PA3500cx, PA4000cx and PA4500cx, for Kyocera CS MA4500ci and PA4500ci, and for Kyocera TASKalfa MA3500ci, MA4500ci and PI4500ci printers";
    homepage = "https://www.kyoceradocumentsolutions.com";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.me-and ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
