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
  version = "0.22.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "arity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QXDCMbZBbHfx/UhJHn3VDgyf9ZEHy/wsld1p47W8A6M=";
  };

  cargoHash = "sha256-fP3BktkkBXrfyUgpekVabi2JVcrH68Xt+p4JneriRYs=";

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
