{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "edusong";
  version = "4.0";

  src = fetchzip {
    name = "${pname}-${version}";
    url = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/eduSong_Unicode.zip";
    hash = "sha256-4NBnwMrYufeZbgSiD2fAhe4tuy0aAA5u9tWwjQQjEQk=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/
    mv *.ttf $out/share/fonts/
  '';

  meta = {
    description = "The MOE Standard Song Font, a Chinese font by the Ministry of Education, ROC (Taiwan)";
    longDescription = ''
      The MOE Standard Song Font is a Chinese Song font provided by
      the Midistry of Education, Republic of China (Taiwan).
      Song or Ming is a category of CKJ typefaces in print.
    '';
    homepage = "https://language.moe.gov.tw/result.aspx?classify_sn=23&subclassify_sn=436&content_sn=48";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
