{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
  nodejs,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
  version = "5.23.1";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PXMwWsp2dwDj67waT5FXsKMgXnbmNFhHR07Jw7ePkx8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-FxKqFjrgothuWZOJySQ+yV1ygVWrrbv3h0hXAwaqHsQ=";

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
