{
  lib,
  buildGoModule,
  dbus,
  fetchFromGitHub,
  installShellFiles,
  makeShellWrapper,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:
let
  version = "0.2.1";
in
buildGoModule {
  pname = "ente-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    rev = "refs/tags/cli-v${version}";
    hash = "sha256-gIDJUj2pn8rndXWN69bZdVfRLVB7AybXHMcioG2NI1k=";
    sparseCheckout = [ "cli" ];
  };

  modRoot = "./cli";

  vendorHash = "sha256-Gg1mifMVt6Ma8yQ/t0R5nf6NXbzLZBpuZrYsW48p0mw=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.AppVersion=cli-v${version}"
  ];

  nativeBuildInputs = [
    dbus
    installShellFiles
    makeShellWrapper
  ];

  postInstall =
    ''
      mv $out/bin/{cli,ente}
    ''
    # ente has to be executed to generate shell completions and check the version
    # for running it safely and in sandbox env we have to use `makeShellWrapper`
    # placing the wrapped ente under /tmp avoids a manual cleanup after `versionCheckHook`
    # using $out makes the path unique and deterministic for setting `versionCheckProgram`
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      DIR=/tmp"$out"
      WRAPPED="$DIR/ente-wrapped"
      mkdir -p "$DIR"
      makeShellWrapper "$out/bin/ente" "$WRAPPED" \
        --set ENTE_CLI_CONFIG_PATH "$DIR" \
        --set ENTE_CLI_SECRETS_PATH "$DIR/secrets"

      installShellCompletion --cmd ente \
        --bash <("$WRAPPED" completion bash) \
        --fish <("$WRAPPED" completion fish) \
        --zsh <("$WRAPPED" completion zsh)
    '';

  nativeInstallCheckInputs = [
    dbus
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgram = "/tmp${placeholder "out"}/ente-wrapped";
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "cli-(.+)"
    ];
  };

  meta = {
    description = "CLI client for downloading your data from Ente";
    longDescription = ''
      The Ente CLI is a Command Line Utility for exporting data from Ente. It also does a few more things, for example, you can use it to decrypting the export from Ente Auth.
    '';
    homepage = "https://github.com/ente-io/ente/tree/main/cli#readme";
    changelog = "https://github.com/ente-io/ente/releases/tag/cli-v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = [
      lib.maintainers.zi3m5f
    ];
    mainProgram = "ente";
  };
}
