{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fatou";
  version = "0.21.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "fatou";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nf/hOUEKqdtAWD003ZQE8W+tGGiRjX+ZvNiqssEEeZE=";
  };

  cargoHash = "sha256-o785a+4E0jn2DzTG5pgFGNUbyX0eZWfP1WExaghB4GU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd fatou \
      --bash target/completions/fatou.bash \
      --fish target/completions/fatou.fish \
      --zsh target/completions/_fatou

    installManPage target/man/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server, formatter, and linter for Julia";
    homepage = "https://fatou.dev/";
    changelog = "https://github.com/jolars/fatou/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jolars ];
    mainProgram = "fatou";
  };
})
