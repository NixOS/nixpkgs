{
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "srgn";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${version}";
    hash = "sha256-bwrV6wj9PrX2cYAnqB0fXiG/vuL28M0q9a+WER0A/9w=";
  };

  cargoHash = "sha256-9quoyNqADezMdziiaGCVIKJWBWaTgrMsfWVUw4Zlo94=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd srgn "--$shell" <("$out/bin/srgn" --completions "$shell")
    done
  '';

  meta = with lib; {
    description = "Code surgeon for precise text and code transplantation";
    license = licenses.mit;
    maintainers = with maintainers; [ magistau ];
    mainProgram = "srgn";
    homepage = "https://github.com/${src.owner}/${src.repo}/";
    downloadPage = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/CHANGELOG.md";
  };
}
