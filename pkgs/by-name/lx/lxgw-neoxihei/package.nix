{
  lib,
  fetchurl,
  stdenvNoCC,
  installFonts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-neoxihei";
  version = "1.305";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${finalAttrs.version}/LXGWNeoXiHei.ttf";
    hash = "sha256-iTz77GBHaPA3hatPNpUI3mjCdCczWaXK3uF+KFKXXVw=";
  };

  unpackPhase = ''
    runHook preUnpack

    cp $src LXGWNeoXiHei.ttf

    runHook postUnpack
  '';

  nativeBuildInputs = [ installFonts ];

  __structuredAttrs = true;

  meta = {
    description = "Simplified Chinese sans-serif font derived from IPAex Gothic";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = lib.licenses.ipa;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
