{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
  version = "5.9.2";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XE1KYOlWehj1peSNj3sKNr6CKchCxRNpIjXHq7slVME=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-Kid5Vp42Pme1AO9fI9e/f24Cdzi1uV8qEULFEvQDKnE=";

  postInstall = ''
    wrapProgram $out/bin/laravel \
      --suffix PATH : ${lib.makeBinPath [ php.packages.composer ]}
  '';

  meta = {
    description = "Laravel application installer";
    homepage = "https://laravel.com/docs#creating-a-laravel-project";
    changelog = "https://github.com/laravel/installer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "laravel";
    maintainers = with lib.maintainers; [ heisfer ];
  };
})
