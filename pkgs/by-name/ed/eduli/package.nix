{
  stdenvNoCC,
  lib,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "eduli";
  version = "3.0";

  src = fetchzip {
    url = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/MoeLI-${finalAttrs.version}.zip";
    hash = "sha256-bDQtLugYPWwJJNusBLEJrgIVufocRK4NIR0CCGaTkyw=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "MOE Li Font, a clerical Chinese font by the Ministry of Education, ROC (Taiwan)";
    longDescription = ''
      The MOE Li Font is a li (clerical script) font provided by
      the Ministry of Education, Republic of China (Taiwan).
      It currently includes 4,808 Chinese characters.
      The clerical script (lishu) is an archaic style of Chinese calligraphy.
    '';
    homepage = "https://language.moe.gov.tw/material/info?m=9fe3fb11-c3d5-41f2-b029-6d18a2c2fd0d";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [
      ShamrockLee
      winterec
    ];
  };
})
