{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "asebi";
  version = "1.011";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://ss1.xrea.com/metasta.s602.xrea.com/asebimin.zip";
    hash = "sha256-FGbG9X18X4FUj++uVNTOO/KppbvWfM+BuPIJHAMzXSI=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    find . -type f -name "*.otf" -exec install -Dm444 -t $out/share/fonts/opentype {} +

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Japanese Mincho typeface derived from IPAmj Mincho, Sammin and Otagi";
    homepage = "https://github.com/metasta/asebi";
    downloadPage = "https://metasta.github.io/asebi/";
    changelog = "https://github.com/metasta/asebi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ipa;
    maintainers = with lib.maintainers; [ lillian0x ];
    platforms = lib.platforms.all;
  };
})
