{
  fetchurl,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-moegirl";
<<<<<<< HEAD
  version = "20251210";
  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/${finalAttrs.version}/moegirl.dict.yaml";
    hash = "sha256-P4AAwApknEaV4PFn6/5rpawp0iOGdDH+muYi+R/iErk=";
=======
  version = "20251109";
  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/${finalAttrs.version}/moegirl.dict.yaml";
    hash = "sha256-GBevsjo6KRd6Uicy2LpMwgZJkluN5n2ID/DAiaKJV74=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontUnpack = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp $src $out/share/rime-data/moegirl.dict.yaml

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/outloudvi/mw2fcitx/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "RIME dictionary file for entries from zh.moegirl.org.cn";
    homepage = "https://github.com/outloudvi/mw2fcitx/releases";
    license = with lib.licenses; [
      unlicense # the tool packaging dictionary
      cc-by-nc-sa-30 # moegirl wiki itself
    ];
  };
})
