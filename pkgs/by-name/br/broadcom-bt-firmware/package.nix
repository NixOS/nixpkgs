{
  lib,
  stdenvNoCC,
  fetchurl,
  cabextract,
  bt-fw-converter,
}:

stdenvNoCC.mkDerivation rec {
  pname = "broadcom-bt-firmware";
  version = "12.0.1.1012";

  src = fetchurl {
    url = "http://download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/04/852bb503-de7b-4810-a7dd-cbab62742f09_7cf83a4c194116648d17707ae37d564f9c70bec2.cab";
    sha256 = "1b1qjwxjk4y91l3iz157kms8601n0mmiik32cs6w9b1q4sl4pxx9";
  };

  nativeBuildInputs = [
    cabextract
    bt-fw-converter
  ];

  unpackCmd = ''
    mkdir -p ${pname}-${version}
    cabextract $src --directory ${pname}-${version}
  '';

  installPhase = ''
    mkdir -p $out/lib/firmware/brcm
    bt-fw-converter -f bcbtums.inf -o $out/lib/firmware/brcm
    for filename in $out/lib/firmware/brcm/*.hcd
    do
      linkname=$(basename $filename | awk 'match($0,/^(BCM)[0-9A-Z]+(-[0-9a-z]{4}-[0-9a-z]{4}\.hcd)$/,c) { print c[1]c[2] }')
      if ! [ -z $linkname ]
      then
        ln -s --relative -T $filename $out/lib/firmware/brcm/$linkname
      fi
    done
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "042frb2dmrqfj8q83h5p769q6hg2b3i8fgnyvs9r9a71z7pbsagq";

  meta = with lib; {
    description = "Firmware for Broadcom WIDCOMM® Bluetooth devices";
    homepage = "https://www.catalog.update.microsoft.com/Search.aspx?q=Broadcom+bluetooth";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
