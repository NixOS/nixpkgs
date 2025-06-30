{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cns11643-kai";
  version = "0-unstable-2025-01-13";

  src = fetchFromGitHub {
    owner = "rypervenche";
    repo = "cns11643-fonts";
    rev = "refs/tags/${version}";
    hash = "sha256-A/4iwNvyzOYEpBzxKeq1xM/6aU6EOCATAr0lQlyckKQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 TW-Kai*.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = {
    description = "Chinese TrueType Kai font by Ministry of Education of Taiwan government";
    homepage = "https://www.cns11643.gov.tw/";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.rypervenche ];
    platforms = lib.platforms.all;
  };
}
