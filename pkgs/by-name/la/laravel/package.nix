{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
}:
php.buildComposerProject (finalAttrs: {
  pname = "laravel";
  version = "5.8.3";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a7DbpjIcT1JbhuzpzQVQ/iiWLAVF/XisrTUsDbR78XQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-NyD/kyqGyE+yO7wCitMipTWnKbGSd/FSQ3iGcXvCv5Y=";

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
