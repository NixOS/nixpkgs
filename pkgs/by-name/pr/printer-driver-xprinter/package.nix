{
  lib,
  stdenv,
  fetchurl,
  unzip,
  dpkg,
  autoPatchelfHook,
  cups,
}:

let
  archMap = {
    "x86_64-linux" = "x64";
    "armv7l-linux" = "armv7l";
    "aarch64-linux" = "aarch64";
    "mips64el-linux" = "mips64";
  };

  driverArch =
    archMap.${stdenv.hostPlatform.system}
      or (throw "printer-driver-xprinter: unsupported platform ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "printer-driver-xprinter";
  version = "3.13.55";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://img5541.weyesimg.com/uploads/xprintertech.com/file/17858308138104.zip";
    hash = "sha256-VtpqYa/36eURdOmfY967aQz0hk9bRf5DJcArx/bVTUw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    unzip
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    cups
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir source
    unzip "$src" -d source

    mkdir deb-source
    dpkg-deb -x \
      source/printer-driver-xprinter_3.13.55_all.deb \
      deb-source

    cd deb-source

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/cups/filter"
    mkdir -p "$out/share/cups/model"

    cp -r \
      usr/share/cups/model/xprinter \
      "$out/share/cups/model/"

    shopt -s nullglob
    filters=(opt/xprinter_printer/printer-driver-xprinter/bin/*-"${driverArch}")

    if (( ''${#filters[@]} == 0 )); then
      echo "No Xprinter filters found for architecture ${driverArch}" >&2
      exit 1
    fi

    for filter in "''${filters[@]}"; do
      name="$(basename "$filter" "-${driverArch}")"

      install -D \
        "$filter" \
        "$out/lib/cups/filter/''${name}-xprinter"
    done

    runHook postInstall
  '';

  meta = {
    description = "CUPS drivers for Xprinter thermal printers";
    homepage = "https://www.xprintertech.com/";
    downloadPage = "https://www.xprintertech.com/download.html";
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
    ];
    license = lib.licenses.unfree;
    platforms = builtins.attrNames archMap;
    maintainers = with lib.maintainers; [
      jordandev-foss
    ];
  };
}
