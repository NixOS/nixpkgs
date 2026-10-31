{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  pkg-config,
  zstd,
  nix-update-script,
  versionCheckHook,
  vscode-extensions,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harper";
  version = "3.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7KUSvmgGIGWJHwZTCewZf/lADYK3pzriFdV24eDjbn0=";
  };

  cargoHash = "sha256-Xj6xYlfg48V/5TEgZr9FpjKAYxzNsTrFUHoaQXIkt1w=";

  cargoBuildFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  cargoTestFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [ zstd ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd harper-cli \
      --bash <($out/bin/harper-cli completion bash) \
      --fish <($out/bin/harper-cli completion fish) \
      --zsh <($out/bin/harper-cli completion zsh)
  '';

  passthru = {
    tests.vscode = vscode-extensions.elijah-potter.harper;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "tests.vscode"
      ];
    };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
      ddogfoodd
    ];
    mainProgram = "harper-ls";
  };
})
