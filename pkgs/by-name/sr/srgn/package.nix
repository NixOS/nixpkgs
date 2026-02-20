{
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "srgn";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${finalAttrs.version}";
    hash = "sha256-bwrV6wj9PrX2cYAnqB0fXiG/vuL28M0q9a+WER0A/9w=";
  };

  cargoHash = "sha256-9quoyNqADezMdziiaGCVIKJWBWaTgrMsfWVUw4Zlo94=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd srgn "--$shell" <("$out/bin/srgn" --completions "$shell")
    done
  '';

  meta = {
    description = "Code surgeon for precise text and code transplantation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magistau ];
    mainProgram = "srgn";
    homepage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/";
    downloadPage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/releases/tag/${finalAttrs.src.rev}";
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/blob/${finalAttrs.src.rev}/CHANGELOG.md";
  };
})
