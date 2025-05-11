# To use this package, use: `services.transmission.webHome = pkgs.flood-for-transmission;`
# The configuration [1] can be modified by overriding floodSettings:
# pkgs.flood-for-transmission.override {
#   floodSettings.SWITCH_COLORS = true;
# };
# [1]: https://github.com/johman10/flood-for-transmission?tab=readme-ov-file#beta-customization
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  floodSettings ? null,
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

  installPhase = ''
    runHook preInstall

    cp -r public $out
    rm $out/config.json.defaults
    touch $out/config.json

    runHook postInstall
  '';

  postInstall = lib.optionalString (floodSettings != null) ''
    echo '${builtins.toJSON floodSettings}' > $out/config.json
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
