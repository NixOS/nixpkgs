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
  version = "0.39.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nklmilojevic";
    repo = "sofka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N9u/v/pcBToekkuAWj0m/hjj1hqIQu3a+d/9mN9mzOI=";
  };

  cargoHash = "sha256-JTzaEWGQc5LkImjNxGmf9tbw+a3AnQz64nfkU9f5so0=";

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
