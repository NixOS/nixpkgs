{
  lib,
  fetchurl,
  stdenvNoCC,
  nix-update-script,
  usePlus ? true,
}:

let
  fontName = if usePlus then "LXGWNeoZhiSong" else "LXGWNeoZhiSongPlus";
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-neozhisong";
  version = "1.055";

  src = fetchurl {
    url = "https://github.com/lxgw/LXGWNeoZhiSong/releases/download/v${finalAttrs.version}/${fontName}.ttf";
    hash =
      if usePlus then
        "sha256-DyrjC9XCwrfCilJ+5OnkzoOk1Iu5CcBm45/idIRb3IE="
      else
        "sha256-Enc/WXnHyDS3Gkdb0vEduieR3eJGmpbubebEbu3EyLs=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/${fontName}.ttf

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Chinese serif font derived from IPAmj Mincho";
    homepage = "https://github.com/lxgw/LXGWNeoZhiSong";
    changelog = "https://github.com/lxgw/LxgwNeoZhiSong/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ipa;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})
