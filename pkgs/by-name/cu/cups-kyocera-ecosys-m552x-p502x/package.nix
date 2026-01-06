{
  stdenv,
  lib,
  fetchzip,
  # can either be "EU" or "Global"; it's unclear what the difference is
  region ? "Global",
}:

stdenv.mkDerivation {
  pname = "cups-kyocera-ecosys-m552x-p502x";
  version = "8.1602";

  src = fetchzip {
    url = "https://www.kyoceradocumentsolutions.de/content/dam/download-center-cf/de/drivers/all/Linux_8_1602_ECOSYS_M5521_5526_P5021_5026_zip.download.zip";
    sha256 = "sha256-XDH5deZmWNghfoO7JaYYvnVq++mbQ8RwLY57L2CKYaY=";
  };

  installPhase = ''
    mkdir -p $out/share/cups/model/Kyocera
    cp ${region}/English/*.PPD $out/share/cups/model/Kyocera/
  '';

  meta = {
    description = "PPD files for Kyocera ECOSYS M5521cdn/M5521cdw/M5526cdn/M5526cdw/P5021cdn/P5021cdw/P5026cdn/P5026cdw";
    homepage = "https://www.kyoceradocumentsolutions.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ theCapypara ];
    platforms = lib.platforms.linux;
  };
}
