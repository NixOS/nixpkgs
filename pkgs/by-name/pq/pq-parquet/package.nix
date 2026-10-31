{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pq-parquet";
  version = "1.0.8";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OrlovEvgeny";
    repo = "pq";
    # tag = "v${finalAttrs.version}";
    rev = "8703bc83def866bb3fe7d66f73b2713627a0fef4";
    hash = "sha256-vfEXdRZGo1OQjrhsOJBGzTPMA0HMnblxLJyoSx586gU=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  cargoHash = "sha256-HTt36nq61By24aVy1zKAEsI08u1oHn9WCb1jDRQ41P4=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pq \
      --bash <($out/bin/pq completions bash) \
      --fish <($out/bin/pq completions fish) \
      --zsh <($out/bin/pq completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The jq of Parquet";
    homepage = "https://github.com/OrlovEvgeny/pq";
    changelog = "https://github.com/OrlovEvgeny/pq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "pq";
  };
})
