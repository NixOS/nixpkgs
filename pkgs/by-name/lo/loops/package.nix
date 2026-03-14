{
  lib,
  fetchFromGitHub,
  php,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  nix-update-script,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "loops";
  version = "1.0.0-beta.6";

  src = fetchFromGitHub {
    owner = "joinloops";
    repo = "loops-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jJf1sFJs5TE9DRgnTAvtNawt1ROjtCuToAJAB+jmoy4=";
  };

  vendorHash = "sha256-oFowe5W0Hpjl3l/mG70bs7tcfSNeh+7hd1Xc8GLfb60=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-+NsMTPKMShajCIzCjLhV4UHZ6rJlOBT12vi61p4fAT0=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
    npmHooks.npmInstallHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Federated image sharing platform";
    license = lib.licenses.agpl3Only;
    homepage = "https://pixelfed.org/";
    maintainers = [ ];
    platforms = php.meta.platforms;
  };
})

