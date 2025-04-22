{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "edukai";
  version = "5.0";

  src = fetchzip {
    name = "${pname}-${version}";
    url = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/edukai-${version}.zip";
    sha256 = "sha256-3+w9n6GJQg9+HfHYukC7tlm4GVs8vEOO23hrLw6qjTY=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/
    mv *.ttf $out/share/fonts/
  '';

  meta = {
    description = "The MOE Kai font, a regular-script-style Chinese character typeface";
    longDescription = ''
        A regular-script-style Chinese character typeface published by the Ministry of Education of the Republic of China (Taiwan). Regular script is also referred to as 楷書, 楷书, kǎishū, 真書, 真书, zhēnshū, 正楷, zhèngkǎi, 楷體, 楷体, kǎitǐ, 正書, 正书, or zhèngshū in Chinese; khải thư in Vietnamese; 楷書, かいしょ, or Kaisho in Japanese.
    '';
    homepage = "http://language.moe.gov.tw/result.aspx?classify_sn=23&subclassify_sn=436&content_sn=47";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
