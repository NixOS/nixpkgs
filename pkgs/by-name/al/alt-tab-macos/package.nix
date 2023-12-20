{ lib
, fetchzip
}:

fetchzip rec {
  pname = "alt-tab-macos";
  version = "6.61.0";

  url = "https://github.com/lwouis/alt-tab-macos/releases/download/v${version}/AltTab-${version}.zip";
  hash = "sha256-rPp3kCdfzm7WcVogPtaYy/ArGqRbYEEHB2bSgwQ4vp0=";

  stripRoot = false;

  postFetch = ''
    shopt -s extglob
    mkdir $out/Applications
    mv $out/!(Applications) $out/Applications
  '';

  meta = with lib; {
    description = "Windows alt-tab on macOS";
    homepage = "https://alt-tab-macos.netlify.app";
    license = licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
}
