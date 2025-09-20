{
  stdenvNoCC,
  fetchurl,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-wenkai-screen";
  version = "1.520";

  srcs = [
    (fetchurl {
      url = "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v${finalAttrs.version}/LXGWWenKaiScreen.ttf";
      hash = "sha256-AxTlH8AZBu66WNbjv45cAuFRrItUeElEvyorEkXKQe4=";
    })
    (fetchurl {
      url = "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v${finalAttrs.version}/LXGWWenKaiMonoScreen.ttf";
      hash = "sha256-hyud3lwGi2W45bnz6qz1ovZuvR3bg6xhDdgXXIVjwsI=";
    })
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    for ttf in $srcs; do
      install -Dm644 -T "$ttf" "$out/share/fonts/truetype/$(stripHash "$ttf")"
    done
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
