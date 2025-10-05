{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cliflux";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "spencerwi";
    repo = "cliflux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Hmdze3so74YHv9JrRHfylWcT1LlBrXVcAiBxigW6wU=";
  };

  cargoHash = "sha256-glA78iRu7SoJZnk6QL7b84jY1+U4RzgUXe/zQpAnK7A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal client for Miniflux RSS reader";
    homepage = "https://github.com/spencerwi/cliflux";
    changelog = "https://github.com/spencerwi/cliflux/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "cliflux";
  };
})
