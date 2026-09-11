{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cliflux";
  version = "1.10.0";

  src = fetchFromCodeberg {
    owner = "spencerwi";
    repo = "cliflux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fzuqgzBVnVIOcRplDKLBskhX9PlMA9LM0f3MnLqzyhk=";
  };

  cargoHash = "sha256-gAfN3kO5wrZ8usKv4C97LT+BAEu9ZD8ZP/GOCrWC7Nk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal client for Miniflux RSS reader";
    homepage = "https://codeberg.org/spencerwi/cliflux";
    changelog = "https://codeberg.org/spencerwi/cliflux/raw/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "cliflux";
  };
})
