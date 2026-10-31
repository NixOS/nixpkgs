{
  lib,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-neoxihei-code";
  version = "1.304";

  src = fetchurl {
    url = "https://github.com/lxgw/NeoXiHei-Code/releases/download/v${version}/NeoXiHeiCode-Regular.ttf";
    hash = "sha256-zp7UFoPonjB75qPi0CQ0VNq5m4ULWfVo6+GxADUx6tE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/NeoXiHeiCode-Regular.ttf

    runHook postInstall
  '';

  meta = {
    description = "Programming font combining LXGW NeoXiHei and M+ monospace (derived from Migu 1M)";
    homepage = "https://github.com/lxgw/NeoXiHei-Code";
    license = lib.licenses.ipa;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ xrelkd ];
  };
}
