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
    description = "The MOE Li font, a clerical-script-style Chinese character typeface";
    longDescription = ''
        A clerical-script-style Chinese character typeface published by the Ministry of Education of the Republic of China (Taiwan). Clerical script is also referred to as 隸書, 隶书, or lìshū in Chinese; lệ thư or chữ lệ in Vietnamese; 예서, 隸書, or yeseo in Korean; 隷書体, れいしょたい, or reishotai in Japanese.
    '';
    homepage = "http://language.moe.gov.tw/result.aspx?classify_sn=23&subclassify_sn=436&content_sn=49";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
