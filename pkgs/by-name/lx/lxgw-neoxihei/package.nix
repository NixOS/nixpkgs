{
  lib,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-neoxihei";
  version = "1.218";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";
    hash = "sha256-TGl4J4r7ueAahrTgsJH0DlucuT2OrW3NzR1jQGwQA7E=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/LXGWNeoXiHei.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simplified Chinese sans-serif font derived from IPAex Gothic";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
