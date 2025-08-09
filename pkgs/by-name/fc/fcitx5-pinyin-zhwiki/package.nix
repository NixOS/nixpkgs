{
  lib,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-pinyin-zhwiki";
  version = "0.2.5";
  date = "20250415";

  src = fetchurl {
    url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/${finalAttrs.version}/zhwiki-${finalAttrs.date}.dict";
    hash = "sha256-8dFBoP3UcYCl6EYojn14Bp7aYe/Z9cf4drSmeheHbLw=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fcitx5/pinyin/dictionaries/zhwiki.dict

    runHook postInstall
  '';

  meta = {
    description = "Fcitx 5 pinyin dictionary from zh.wikipedia.org";
    homepage = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki";
    license = with lib.licenses; [
      unlicense
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.all;
  };
})
