{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "andagii";
  version = "1.0.2";

  src = fetchzip {
    url = "http://www.i18nguy.com/unicode/andagii.zip";
    curlOpts = "--user-agent 'Mozilla/5.0'";
    hash = "sha256-U7wC55G8jIvMMyPcEiJQ700A7nkWdgWK1LM0F/wgDCg=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "http://www.i18nguy.com/unicode/unicode-font.html";
    description = "Unicode Plane 1 Osmanya script font";
    maintainers = [ lib.maintainers.raskin ];
    license = lib.licenses.unfreeRedistributable; # upstream uses the term copyleft only
    platforms = lib.platforms.all;
  };
}
