{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
  nodejs,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
  version = "5.19.0";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k1A3Ro8Zeu4nzjp7rWW11R0ijfp+Wo/29CESDliimTs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-ioYwWKRSeUixxI3Jq8XmnDOsGtvHK9ZF2qJXgL6AD2Y=";

  # Adding npm (nodejs) and php composer to path
  postInstall = ''
    wrapProgram $out/bin/laravel \
      --suffix PATH : ${
        lib.makeBinPath [
          php.packages.composer
          nodejs
        ]
      }
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Laravel application installer";
    homepage = "https://laravel.com/docs#creating-a-laravel-project";
    changelog = "https://github.com/laravel/installer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "laravel";
    maintainers = with lib.maintainers; [ heisfer ];
  };
})
