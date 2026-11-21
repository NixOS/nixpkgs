{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  aws-lc,
  zstd,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sofka";
  version = "0.37.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nklmilojevic";
    repo = "sofka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5n9/eZsZa7EIwm8bZvG3cAmXusgLmvPQREEcWSqrIts=";
  };

  cargoHash = "sha256-8vSD8EQmzMZM4zuKyPB9gjVHDncHkVycp7sU7/7TUNk=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    aws-lc
    zstd
  ];

  nativeCheckInputs = [
    cacert
  ];

  checkFlags = [
    # `complete` builtin is unavailable in stdenv's minimal bash
    "--skip=generated_bash_script_completes_context_values"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sofka \
      --bash <($out/bin/sofka completion bash) \
      --fish <($out/bin/sofka completion fish) \
      --zsh <($out/bin/sofka completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes TUI, reimagined in Rust";
    homepage = "https://github.com/nklmilojevic/sofka";
    changelog = "https://github.com/nklmilojevic/sofka/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [ kevinastone ];
    mainProgram = "sofka";
    platforms = lib.platforms.unix;
  };
})
