{
  stdenvNoCC,
  fetchurl,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-wenkai-tc";
  version = "1.521";
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKaiTC/releases/download/v${finalAttrs.version}/lxgw-wenkai-tc-v${finalAttrs.version}.tar.gz";
    hash = "sha256-secUl91sR6AgHD1ac96ka4BtaMjdQYUPnzVM7jgv5n4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/lxgw/LxgwWenKaiTC";
    description = "Traditional Chinese Edition of LXGW WenKai";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lebensterben ];
  };
})
