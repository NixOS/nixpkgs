{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "edukai";
  version = "4.0";

  src = fetchzip {
    name = "${pname}-${version}";
    url = "http://language.moe.gov.tw/001/Upload/Files/site_content/M0001/edukai-4.0.zip";
    sha256 = "10m9srvbazvg9gc43943dc89rjzcfc8mm4lx9gb5hnplrn22zrcn";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/
    mv *.ttf $out/share/fonts/
  '';

  meta = {
    description = "The MOE Standard Kai Font, a Chinese font by the Ministry of Education, ROC (Taiwan)";
    longDescription = ''
      The MOE Standard Kai Font is a kai (regular srcipt) font
      provided by
      the Midistry of Education, Republic of China (Taiwan).
      It currently includes 13,076 Chinese characters.
    '';
    homepage = "http://language.moe.gov.tw/result.aspx?classify_sn=23&subclassify_sn=436&content_sn=47";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
