# To use this package, use: `services.transmission.webHome = pkgs.flood-for-transmission;`
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "flood-for-transmission";
  version = "2025-07-19T10-51-22";

  src = fetchFromGitHub {
    owner = "johman10";
    repo = "flood-for-transmission";
    tag = finalAttrs.version;
    hash = "sha256-2oHEVvZZcxH9RBKreaiwFKp7Iu5ijYdpXdgVknCxwKw=";
  };

  npmDepsHash = "sha256-IUdsUGsm6yAbXqf4UGkz1VPa366TnWsTakkbywbLeTU=";

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
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ al3xtjames ];
    platforms = lib.platforms.all;
  };
})
