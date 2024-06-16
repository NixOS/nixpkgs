{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
}:
php.buildComposerProject (finalAttrs: {
  pname = "laravel";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LQABZnmKgJ8qkymmSjhjc+x1qZ/tFqFyQbfeGZECxok=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-f18N2qNCUFetCaHaC4X6Benq70x21SVQ3YSs8kovK1g=";

  postInstall = ''
    wrapProgram $out/bin/laravel \
      --suffix PATH : ${lib.makeBinPath [ php.packages.composer ]}
  '';

  meta = {
    description = "The Laravel application installer";
    homepage = "https://laravel.com/docs#creating-a-laravel-project";
    changelog = "https://github.com/laravel/installer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "laravel";
    maintainers = with lib.maintainers; [ heisfer ];
  };
})
