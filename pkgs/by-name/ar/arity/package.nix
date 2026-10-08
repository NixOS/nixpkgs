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
  version = "0.19.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "arity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MirIe+AOAlhgQi26P7h/NFOYAnKzHdd+aYvXlpULbCA=";
  };

  cargoHash = "sha256-NEyZQj6po/O0qTrI4OrEY0n8ME8Pdn5VnNuQs+/wQf0=";

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
