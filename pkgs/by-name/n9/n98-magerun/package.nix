{
  lib,
  fetchFromGitHub,
  php81,
  nix-update-script,
}:

php81.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun";
    tag = finalAttrs.version;
    hash = "sha256-/RffdYgl2cs8mlq4vHtzUZ6j0viV8Ot/cB/cB1dstFM=";
  };

  vendorHash = "sha256-huYLbqJaxeSST2WGcSdk4gR3d3KWSkIK/6tzVpCw0oQ=";

  passthru.updateScript = nix-update-script {
    # Excludes 1.x versions from the Github tags list
    extraArgs = [
      "--version-regex"
      "^(2\\.(.*))"
    ];
  };

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento1/OpenMage developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun";
    teams = [ lib.teams.php ];
  };
})
