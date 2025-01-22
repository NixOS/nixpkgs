{
  lib,
  fetchurl,
  nix-update-script,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-pinyin-moegirl";
  version = "20250111";

  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/${finalAttrs.version}/moegirl.dict";
    hash = "sha256-ooYpkrqeOc5OrjeGTbobfv4b8x5uV/ot3QaU3d5MRLQ=";
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
    license = with lib.licenses; [
      unlicense
      cc-by-nc-sa-30
    ];
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.all;
  };
})
