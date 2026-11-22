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
buildGoModule (finalAttrs: {
  pname = "dbtpl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "xo";
    repo = "dbtpl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mY3UyTDlofSgkOjlJTVCtJz26DVoxzOjzZ9paFBpB3M=";
  };

  vendorHash = "sha256-Gr2gNIasf5/CGqUx1ONkqICcjJvOQyC322S/lH+a0U0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  modPostBuild = ''
    substituteInPlace vendor/github.com/xo/ox/ox.go \
        --replace-warn "ver := \"(devel)\"" "ver := \"${finalAttrs.version}\""
  '';

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/dbtpl"
        else
          lib.getExe buildPackages.dbtpl;
    in
    ''
      installShellCompletion --cmd dbtpl \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool to generate idiomatic Go code for SQL databases supporting PostgreSQL, MySQL, SQLite, Oracle, and Microsoft SQL Server";
    homepage = "https://github.com/xo/dbtpl";
    changelog = "https://github.com/xo/dbtpl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      shellhazard
    ];
    mainProgram = "dbtpl";
  };
})
