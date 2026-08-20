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
  version = "0.16.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "badness";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3aGxmn7H+OHJbjsLn3P6FxkXYGSe5xJoRGw/pkkQApM=";
  };

  cargoHash = "sha256-S0npMUULDwkMgl8z8W8vunL+E9ZMlfQk5P/8f3bgo0Y=";

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
