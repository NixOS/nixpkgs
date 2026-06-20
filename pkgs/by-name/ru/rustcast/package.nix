{
  nix-update-script,
  fetchFromGitHub,
  rustPlatform,
  apple-sdk,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustcast";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "unsecretised";
    repo = "rustcast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-88vg+xdASskbYwLbEPGmHf8P1PL4PihJDXT1ua/cfCQ=";
  };

  nativeBuildInputs = [
    apple-sdk
  ];

  cargoHash = "sha256-IvpvbsnWWI1I/1PmVfP6qXf8DzRknRBJjMixUp01xo8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/unsecretised/rustcast/releases/tag/v${finalAttrs.version}";
    description = "Modern Spotlight Alternative made opensource";
    homepage = "https://github.com/unsecretised/rustcast";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
