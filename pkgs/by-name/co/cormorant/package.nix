{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cormorant";
  version = "4.002";

  src = fetchFromGitHub {
    owner = "CatharsisFonts";
    repo = "Cormorant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vYn6MV+P+YVH329NM9tfAsNG8bsgGTJtDLOgnNYRMFk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf
    install -m444 -Dt $out/share/fonts/opentype fonts/otf/*.otf

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source display font family";
    longDescription = "Cormorant is a free display type family developed by Christian Thalmann (Catharsis Fonts).";
    homepage = "https://www.behance.net/gallery/28579883/Cormorant-an-open-source-display-font-family";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mrbjarksen ];
  };
})
