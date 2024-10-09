{
  stdenvNoCC,
  fetchurl,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-wenkai-screen";
  version = "1.330";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v${finalAttrs.version}/LXGWWenKaiScreen.ttf";
    hash = "sha256-3C6gZmL5Bn6+26TfI2UdCCnGI8Vw4UTFJRc8n6qlP5o=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 "$src" "$out/share/fonts/truetype/LXGWWenKaiScreen.ttf"
    runHook postInstall
  '';

  meta = {
    description = "LXGW WenKai font optimized for screen reading";
    homepage = "https://github.com/lxgw/LxgwWenKai-Screen";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lebensterben ];
  };
})
