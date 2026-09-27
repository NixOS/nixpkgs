{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-eval-jobs,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "colmena";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "colmena";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YkaWZQV/OO4ZEmin+RHZ/6qFfBah/qSSXduTQMZTNR0=";
  };

  cargoHash = "sha256-4Pwql4jz8nP9jOcppSoCEXryT9gN/ZWXFtzvcrjZYVA=";

  buildInputs = [ nix-eval-jobs ];
  env.NIX_EVAL_JOBS = lib.getExe nix-eval-jobs;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd colmena \
      --bash <($out/bin/colmena gen-completions bash) \
      --fish <($out/bin/colmena gen-completions fish) \
      --zsh <($out/bin/colmena gen-completions zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # Recursive Nix is not stable yet
  doCheck = false;

  passthru = {
    # We guarantee CLI and Nix API stability for the same minor version
    apiVersion = builtins.concatStringsSep "." (lib.take 2 (lib.splitVersion finalAttrs.version));
  };

  meta = {
    description = "Simple, stateless NixOS deployment tool";
    homepage = "https://colmena.cli.rs/${finalAttrs.passthru.apiVersion}";
    downloadPage = "https://github.com/nix-community/colmena";
    changelog = "https://github.com/nix-community/colmena/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stepbrobd
      zhaofengli
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "colmena";
  };
})
