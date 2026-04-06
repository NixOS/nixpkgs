{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
  nodejs,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
  version = "5.25.2";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tQBJ156KYcCVwf+xNzCL+4rh/ru1imTiD4Uu8vD16sw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-nasF4IHxGvOQHVJ6S6+a8DA5iSvDvyH3Oxw8Zw4MdAY=";

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
