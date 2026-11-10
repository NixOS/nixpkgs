{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "panache";
  version = "3.17.2";

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "panache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wa1IKmOhT2dARMGi1ScjOCC+z90u6sDwgbNk3xhk2+c=";
  };

  cargoHash = "sha256-djEzxH+Da8LiZ3RnCrkCBaOEDepuArklMdwQMWcRvmI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd panache \
      --bash target/completions/panache.bash \
      --fish target/completions/panache.fish \
      --zsh target/completions/_panache

    installManPage target/man/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server, formatter, and linter for Pandoc, Quarto, and R Markdown";
    homepage = "https://github.com/jolars/panache";
    changelog = "https://github.com/jolars/panache/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jolars ];
    mainProgram = "panache";
  };
})
