{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "dbtpl";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "xo";
    repo = "dbtpl";
    rev = "v${version}";
    hash = "sha256-r0QIgfDSt7HWnIDnJWGbwkqkXWYWGXoF5H/+zS6gEtE=";
  };

  vendorHash = "sha256-5ISkkGnuhmmFVGiHrgPD4LepFNjHUab28Siuqt6ZKdA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  preBuild = ''
    substituteInPlace vendor/github.com/xo/ox/ox.go \
        --replace-warn "ver := \"(devel)\"" "ver := \"${version}\""
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd dbtpl \
        --bash <(${emulator} $out/bin/dbtpl completion bash) \
        --fish <(${emulator} $out/bin/dbtpl completion fish) \
        --zsh <(${emulator} $out/bin/dbtpl completion zsh)
    ''
  );

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool to generate idiomatic Go code for SQL databases supporting PostgreSQL, MySQL, SQLite, Oracle, and Microsoft SQL Server";
    homepage = "https://github.com/xo/dbtpl";
    changelog = "https://github.com/xo/dbtpl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      shellhazard
    ];
    mainProgram = "dbtpl";
  };
}
