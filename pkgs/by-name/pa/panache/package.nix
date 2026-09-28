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
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "panache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tm9YUTjSoHHHkQLbk7JZZL6jQ/KPFJzmWuC16UuhnUM=";
  };

  cargoHash = "sha256-IZtOYt8IizHIYac7iGTyZoVK3vvAyC7WwSFoEYMyNBo=";

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
