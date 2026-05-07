{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "nom";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "guyfedwards";
    repo = "nom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q2vnReYAxU8UcTPIy1dIVO9jQwC+9dYfO9cDls0Voyo=";
  };

  vendorHash = "sha256-pPd7wpZ55thW0Xq2c/0qSAlGQ71tE8GptsEBJD839Bg=";

  ldflags = [
    "-X 'main.version=${finalAttrs.version}'"
  ];

  # only run xdg-specific test on linux
  checkFlags = lib.optional stdenv.hostPlatform.isDarwin "-skip=^TestNewDefaultWithXDGConfigHome$";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/guyfedwards/nom";
    changelog = "https://github.com/guyfedwards/nom/releases/tag/v${finalAttrs.version}";
    description = "RSS reader for the terminal";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nadir-ishiguro
      matthiasbeyer
    ];
    mainProgram = "nom";
  };
})
