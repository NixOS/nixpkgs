{
  lib,
  buildGoModule,
  ente-cli,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,
  testers,
}:
let
  version = "0.2.2";

  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
buildGoModule {
  pname = "ente-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    rev = "refs/tags/cli-v${version}";
    hash = "sha256-ynbljYl73XwCnt3RUNmOYdrN8FX3sJ+3qDhWa8m2YJs=";
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

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    ''
      mv $out/bin/{cli,ente}
    ''
    # running ente results in the following errors:
    # > mkdir /homeless-shelter: permission denied
    # > error getting password from keyring: exec: "dbus-launch": executable file not found in $PATH
    # fix by setting ENTE_CLI_CONFIG_PATH to $TMP and ENTE_CLI_SECRETS_PATH to a non existing path
    # also guarding with `isLinux` because ENTE_CLI_SECRETS_PATH doesn't help on darwin:
    # > error setting password in keyring: exit status 195
    #
    + lib.optionalString (stdenv.buildPlatform.isLinux && canExecute) ''
      export ENTE_CLI_CONFIG_PATH=$TMP
      export ENTE_CLI_SECRETS_PATH=$TMP/secrets

      installShellCompletion --cmd ente \
        --bash <($out/bin/ente completion bash) \
        --fish <($out/bin/ente completion fish) \
        --zsh <($out/bin/ente completion zsh)
    '';

  passthru = {
    # only works on linux, see comment above about ENTE_CLI_SECRETS_PATH on darwin
    tests.version = lib.optionalAttrs stdenv.hostPlatform.isLinux (
      testers.testVersion {
        package = ente-cli;
        command = ''
          env ENTE_CLI_CONFIG_PATH=$TMP \
              ENTE_CLI_SECRETS_PATH=$TMP/secrets \
              ente version
        '';
        version = "Version cli-v${ente-cli.version}";
      }
    );
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "cli-(.+)"
      ];
    };
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
