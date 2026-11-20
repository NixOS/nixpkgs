{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "badness";
  version = "0.26.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "badness";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+mZLtfViQKA5o6A2E/AIq/mnXlIdWT4aVhUzghDxAJU=";
  };

  cargoHash = "sha256-amu3Rj4Qkayhg2kys2lor7A6LhRif5L1a1xIiTteXdQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd badness \
      --bash target/completions/badness.bash \
      --fish target/completions/badness.fish \
      --zsh target/completions/_badness

    installManPage target/man/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server, formatter, and linter for LaTeX";
    homepage = "https://badness.dev/";
    changelog = "https://github.com/jolars/badness/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jolars ];
    mainProgram = "badness";
  };
})
