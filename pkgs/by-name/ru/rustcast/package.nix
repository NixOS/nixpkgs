{
  nix-update-script,
  fetchFromGitHub,
  rustPlatform,
  apple-sdk,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustcast";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "unsecretised";
    repo = "rustcast";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2YyXWVXbY1+LW2okbux7IbBtQjq43yv2smtnbFwyqgA=";
  };

  nativeBuildInputs = [
    apple-sdk
  ];

  cargoHash = "sha256-87bFzVMPuyOOXahvq6PVhiQLtbrQTfcN0wLtjEDZJmY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern Spotlight Alternative made opensource.";
    homepage = "https://github.com/unsecretised/rustcast";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
