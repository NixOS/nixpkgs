{
  lib,
  fetchurl,
  nix-update-script,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-pinyin-moegirl";
  version = "20240609";

  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/${finalAttrs.version}/moegirl.dict";
    hash = "sha256-dXFV0kVr8hgT17Jmr28PiYTiELm8kS/KM71igHXA6hs=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fcitx5/pinyin/dictionaries/moegirl.dict

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fcitx 5 pinyin dictionary from zh.moegirl.org.cn";
    homepage = "https://github.com/outloudvi/mw2fcitx";
    license = with lib.licenses; [ unlicense cc-by-nc-sa-30 ];
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.all;
  };
})
