{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "koto-ls";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "koto-lang";
    repo = "koto-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a2YGjAZvLyPRfFdZdd0z7sbijS1RCPa5wY2DkJZwbmk=";
  };

  cargoHash = "sha256-GFgIW+x+kncf1OTWZZZjD9yoLEwW01pWAUnJQCpPFhQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for Koto";
    homepage = "https://github.com/koto-lang/koto-ls";
    changelog = "https://github.com/koto-lang/koto-ls/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "koto-ls";
  };
})
