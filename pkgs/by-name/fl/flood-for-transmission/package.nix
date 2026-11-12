# To use this package, use: `services.transmission.webHome = pkgs.flood-for-transmission;`
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "flood-for-transmission";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "johman10";
    repo = "flood-for-transmission";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c1K7ldraw9lzVtABz39B9569jHEuo6N3Iy8aCCfBOXE=";
  };

  npmDepsHash = "sha256-yD9VwnAqE+k2/Z60YdJD6F1f4Cn3fcROCTopDq+DUWU=";

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    cp -r public $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flood clone for Transmission";
    homepage = "https://github.com/johman10/flood-for-transmission";
    downloadPage = "https://github.com/johman10/flood-for-transmission/releases";
    changelog = "https://github.com/johman10/flood-for-transmission/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ al3xtjames ];
    platforms = lib.platforms.all;
  };
})
