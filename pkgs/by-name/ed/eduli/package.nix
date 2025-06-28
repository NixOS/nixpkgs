{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "eduli";
  version = "3.0";

  src = fetchzip {
    name = "${pname}-${version}";
    url = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/MoeLI-3.0.zip";
    hash = "sha256-bDQtLugYPWwJJNusBLEJrgIVufocRK4NIR0CCGaTkyw=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/
    for name in *.ttf; do
      mv "$name" "$out/share/fonts/$(echo $name | sed -r 's/(.*)\(.*\)\.ttf/\1.ttf/')"
    done
  '';

  meta = {
    description = "MOE Li Font, a clerical Chinese font by the Ministry of Education, ROC (Taiwan)";
    longDescription = ''
      The MOE Li Font is a li (clerical srcipt) font
      provided by
      the Midistry of Education, Republic of China (Taiwan).
      It currently includes 4,808 Chinese characters.
      The clerical script (lishu) is an archaic style of Chinese calligraphy.
    '';
    homepage = "http://language.moe.gov.tw/result.aspx?classify_sn=23&subclassify_sn=436&content_sn=49";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
