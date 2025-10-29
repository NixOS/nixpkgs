{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lintspec";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dd9j4eGXhNyaTOMiKK0qi8BW1Zy1kZ6+ZVMB7rrq4gE=";
  };

  cargoHash = "sha256-u83OgBEbZ4b2CLZv/M9Wv0tum3ZKZGOuba0leqfMDoo=";
  cargoBuildFlags = [
    "--package"
    "lintspec"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lintspec \
      --bash <($out/bin/lintspec completions -s bash) \
      --fish <($out/bin/lintspec completions -s fish) \
      --zsh <($out/bin/lintspec completions -s zsh)
  '';

  meta = {
    description = "Blazingly fast linter for NatSpec comments in Solidity code";
    homepage = "https://github.com/beeb/lintspec";
    changelog = "https://github.com/beeb/lintspec/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "lintspec";
  };
})
