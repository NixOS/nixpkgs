{
  stdenvNoCC,
  lib,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "edusong";
  version = "4.4";

  src = fetchzip {
    name = "edusong-${finalAttrs.version}";
    url = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/eduSong_Unicode.zip";
    hash = "sha256-+wH6I0sOfzytstDNT81LMuqknGQuYekl31e1tYaDvRg=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "MOE Song font, a Song-style Chinese character typeface";
    longDescription = ''
      A Song-style Chinese character typeface published by the Ministry of Education of the Republic of China (Taiwan). The Song style is also referred to as 宋體, 宋体, sòngtǐ, 明體, 明体, or míngtǐ, in Chinese; 명조체, 明朝體, or myeongjo in Korean; 明朝体, みんちょうたい, or minchōtai in Japanese.
    '';
    homepage = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/edusun.pdf";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [
      ShamrockLee
      winterec
    ];
  };
})
