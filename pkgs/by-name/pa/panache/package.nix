{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "panache";
  version = "2.45.0";

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "panache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IBWZmDqbDt4zf2wL6hVhWGq+JAwte+NO90jUvVtr/YE=";
  };

  cargoHash = "sha256-vXSVNPc4h3yAAdWxVg9/7Fkxq6PXEjDcWGjFj6FREEI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  postInstall = ''
    installShellCompletion --cmd panache \
      --bash target/completions/panache.bash \
      --fish target/completions/panache.fish \
      --zsh target/completions/_panache

    installManPage target/man/*
  '';

  meta = {
    description = "Language server, formatter, and linter for Pandoc, Quarto, and R Markdown";
    homepage = "https://github.com/jolars/panache";
    changelog = "https://github.com/jolars/panache/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jolars ];
    mainProgram = "panache";
  };
})
