{
  stdenvNoCC,
  lib,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "edukai";
  version = "5.1";

  src = fetchzip {
    url = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/edukai-${finalAttrs.version}.zip";
    sha256 = "sha256-B4TwTPX1dsq6rB4YunY6q2yx2OJhNhmn3an/dJwDPJc=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "MOE Standard Kai Font, a Chinese font by the Ministry of Education, ROC (Taiwan)";
    longDescription = ''
      The MOE Standard Kai Font is a kai (regular script) font
      provided by the Ministry of Education, Republic of China (Taiwan).
      It currently includes 13,084 Chinese characters.
    '';
    homepage = "https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/edukai.pdf";
    license = lib.licenses.cc-by-nd-30;
    maintainers = with lib.maintainers; [
      ShamrockLee
      winterec
    ];
  };
})
