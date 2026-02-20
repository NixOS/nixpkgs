{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
  nodejs,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
  version = "5.24.5";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wFyXg92bW7hZBKubj4Gf6nXnFpEpD3aUXv7mF7XbYQw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-hEr7VX4ZwuS7HUSNOvWCy+FOufTE1fMpJih37ZReoro=";

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
