{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arity";
  version = "0.31.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "arity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qi0c+Ok16MaQSmsYf07gWq0Ueyo1RV3GuQu1GJpw8N0=";
  };

  cargoHash = "sha256-NWc1axXO1AWfchYr4Fa59b2ehGiz0eTDsTu4Lx994OA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd arity \
      --bash target/completions/arity.bash \
      --fish target/completions/arity.fish \
      --zsh target/completions/_arity

    installManPage target/man/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server, formatter, and linter for R";
    homepage = "https://arity.cc";
    changelog = "https://github.com/jolars/arity/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jolars ];
    mainProgram = "arity";
  };
})
