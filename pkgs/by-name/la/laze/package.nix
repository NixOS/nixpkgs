{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  installShellFiles,
  writableTmpDirAsHomeHook,
  ninja,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "laze";
  version = "0.1.38";

  src = fetchFromGitHub {
    owner = "kaspar030";
    repo = "laze";
    tag = finalAttrs.version;
    hash = "sha256-8n22euQquEuMDcF7TN7rJkBK6jrZuYlRWegiXccWXFY=";
  };

  cargoHash = "sha256-M0RrtEAs7nYNr3nnISGX+/49PLdxNU0CkIhZn9wRJjU=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    wrapProgram "$out/bin/laze" \
      --suffix PATH : ${lib.makeBinPath [ ninja ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd laze \
      --bash <($out/bin/laze completion --generate bash) \
      --fish <($out/bin/laze completion --generate fish) \
      --zsh <($out/bin/laze completion --generate zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Fast, declarative meta build system for C/C++/Rust projects, based on Ninja";
    mainProgram = "laze";
    homepage = "https://github.com/kaspar030/laze";
    changelog = "https://github.com/kaspar030/laze/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ dannixon ];
  };
})
