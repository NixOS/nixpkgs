{
  lib,
  fetchurl,
  nix-update-script,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-pinyin-minecraft";
  version = "0.1.20260325";

  src = fetchurl {
    url = "https://github.com/oldherl/fcitx5-pinyin-minecraft/releases/download/${finalAttrs.version}/minecraft-cn.dict";
    hash = "sha256-FjBqxj7VzzbZZCUIJHTBGoVZRDNvX/qQMPn0uaQHgDU=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fcitx5/pinyin/dictionaries/minecraft.dict

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fcitx 5 pinyin dictionary from zh.minecraft.wiki";
    homepage = "https://github.com/oldherl/fcitx5-pinyin-minecraft";
    license = with lib.licenses; [
      unlicense
      cc-by-nc-sa-30
    ];
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.all;
  };
})
