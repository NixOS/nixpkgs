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
  version = "0.18.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "arity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZB/1SgJFom4U5KztBAfMztXsG0/T5tETQZxsRt6N8jY=";
  };

  cargoHash = "sha256-uwQlfK6YXqXNRyZaYTnoEzXn21l01k1Fuw903Gn/7AU=";

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
