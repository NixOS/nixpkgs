{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
  version = "5.12.2";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YV6dUaDR2Xyp/RBj1GKE4wGP0r3eat8uiw2anMZrDg4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-CTvSpOL3d/8i5C7BXP8gSPiOxldouuU6Lwmx04/kMZg=";

  postInstall = ''
    wrapProgram $out/bin/laravel \
      --suffix PATH : ${lib.makeBinPath [ php.packages.composer ]}
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
