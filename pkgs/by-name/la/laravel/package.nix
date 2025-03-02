{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
  nodejs ? nodejs,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
  version = "5.13.0";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-etTSaaZRfrwPRWu7j/P2ZOKPnYKqtkYeW9FuO8xoSqY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-lin4TOyCannSZSuQ9tQCWl62BvYoYfiuJ1V1COvegkU=";

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
