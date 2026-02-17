{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sitelen-seli-kiwen";
  version = "2.0";

  src = fetchzip {
    url = "https://github.com/kreativekorp/sitelen-seli-kiwen/releases/download/${finalAttrs.version}/sitelenselikiwen.zip";
    stripRoot = false;
    hash = "sha256-Ku4+ETI5nXobavjuOnXPuvLHsH3gGsdHOUdv90afADM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{opentype,truetype}
    mv *.eot $out/share/fonts/opentype/
    mv *.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Handwritten sitelen pona font supporting UCSUR";
    homepage = "https://www.kreativekorp.com/software/fonts/sitelenselikiwen/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ somasis ];
  };
})
