{
  fetchurl,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-moegirl";
  version = "20250711";
  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/${finalAttrs.version}/moegirl.dict.yaml";
    hash = "sha256-gs/JhdSeLFkBKvBdVRxk3RhqlkOhly18w4Pz63GG814=";
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
