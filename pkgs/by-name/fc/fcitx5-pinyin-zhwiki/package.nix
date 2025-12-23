{
  lib,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-pinyin-zhwiki";
  version = "0.3.0";
  date = "20251104";

  srcs = [
    (fetchurl {
      url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/${finalAttrs.version}/web-slang-${finalAttrs.date}.dict";
      hash = "sha256-MI0gqLxtgV5gnSFI5nqFTKt0UTQec/VNKgfhptOTBo8=";
    })
    (fetchurl {
      url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/${finalAttrs.version}/zhwiki-${finalAttrs.date}.dict";
      hash = "sha256-bYp4HRUeXMUO7bkjmhp9nfotnBvyVRIROSeT7VapAKc=";
    })
    (fetchurl {
      url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/${finalAttrs.version}/zhwikisource-${finalAttrs.date}.dict";
      hash = "sha256-oxNebop+zFPMkk9swunPCl3XZG4smMw0p9ytaSdEFVE=";
    })
    (fetchurl {
      url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/${finalAttrs.version}/zhwiktionary-${finalAttrs.date}.dict";
      hash = "sha256-xizpn53RPXlQYnB7Eyqg0mOOO8DAZTWZzDHT3wrboPE=";
    })
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    for dict in $srcs; do
      install -D $dict $out/share/fcitx5/pinyin/dictionaries/$(basename $(stripHash $dict) | sed 's/-[0-9]\{8\}//')
    done

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
