{
  lib,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-neoxihei";
  version = "1.121";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";
    hash = "sha256-3+th4alWV+i9kRT4F5tx8kOD4j8emcN2melcyN/mMMQ=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/LXGWNeoXiHei.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Simplified Chinese sans-serif font derived from IPAex Gothic";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
