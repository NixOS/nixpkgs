{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "edusong";
  version = "4.2";
  # Do not trust the version 4.0/4.00 specified in edusun.pdf on the homepage, which describes the Big5 version of the font.
  # This Unicode version has its dedicated version in the OpenType name table.
  # Nevertheless, there are three records in the name table (in different languages) and they are inconsistent.
  # “Version 4.2, December, 2024” is the latest record, and is consistent with the filename.

  src = fetchzip {
    name = "edusong-${finalAttrs.version}";
    url = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/eduSong_Unicode.zip";
    hash = "sha256-4NBnwMrYufeZbgSiD2fAhe4tuy0aAA5u9tWwjQQjEQk=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/
    mv eduSong_Unicode*.ttf $out/share/fonts/eduSong_Unicode\(2024年12月\).ttf
  '';
  # The original filename in the zip has (2024年12月) encoded in Big5, resulting in garbage characters.

  meta = {
    description = "MOE Song font, a Song-style Chinese character typeface";
    longDescription = ''
      A Song-style Chinese character typeface published by the Ministry of Education of the Republic of China (Taiwan). Its family name is MOESongUN (UN stands for Unicode). The Song style is also referred to as 宋體, 宋体, sòngtǐ, 明體, 明体, or míngtǐ, in Chinese; 명조체, 明朝體, or myeongjo in Korean; 明朝体, みんちょうたい, or minchōtai in Japanese.
    '';
    homepage = "https://language.moe.gov.tw/result.aspx?classify_sn=23&subclassify_sn=436&content_sn=48";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
})
