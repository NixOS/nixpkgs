{
  lib,
  fetchurl,
  nix-update-script,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-pinyin-moegirl";
  version = "20241211";

  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/${finalAttrs.version}/moegirl.dict";
    hash = "sha256-yJYQ/zHFH2dTjkZMH4aM1U6RDNGljgl8iB3Eq5UwY9Q=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fcitx5/pinyin/dictionaries/moegirl.dict

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Fcitx 5 pinyin dictionary from zh.moegirl.org.cn";
    homepage = "https://github.com/outloudvi/mw2fcitx";
    license = with licenses; [
      unlicense
      cc-by-nc-sa-30
    ];
    maintainers = with maintainers; [ Guanran928 ];
    platforms = platforms.all;
  };
})
