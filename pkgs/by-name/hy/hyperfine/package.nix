{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyperfine";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hyperfine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-END6Zn5v/mfww/hg+VW76YCzQn/NJA3wJIFNMs8Mq1E=";
  };

  cargoHash = "sha256-cEEuQKYPJRm/QGv028jYKB6T1D1ETxFvOcOkmZaiLIY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/hyperfine.1

    installShellCompletion \
      $releaseDir/build/hyperfine-*/out/hyperfine.{bash,fish} \
      --zsh $releaseDir/build/hyperfine-*/out/_hyperfine
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Command-line benchmarking tool";
    homepage = "https://github.com/sharkdp/hyperfine";
    changelog = "https://github.com/sharkdp/hyperfine/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      mdaniels5757
      thoughtpolice
    ];
    mainProgram = "hyperfine";
  };
})
