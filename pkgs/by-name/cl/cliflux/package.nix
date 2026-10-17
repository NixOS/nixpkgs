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
  version = "1.9.2";

  src = fetchFromCodeberg {
    owner = "spencerwi";
    repo = "cliflux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xHGbj9bMsyH2pDgDgvZp/N9JI3z6KzkLQVs8Hx/hNf8=";
  };

  cargoHash = "sha256-c5jmf9ci095zUq/DRCDxuv8YuhGT8/SdeZP/Io5xOos=";

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
