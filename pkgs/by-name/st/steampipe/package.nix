{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeWrapper,
  nix-update-script,
  steampipe,
  testers,
}:

buildGoModule rec {
  pname = "steampipe";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe";
    rev = "refs/tags/v${version}";
    hash = "sha256-Oz1T9koeXnmHc5oru1apUtmhhvKi/gAtg/Hb7HKkkP0=";
  };

  vendorHash = "sha256-U0BeGCRLjL56ZmVKcKqrrPTCXpShJzJq5/wnXDKax6g=";
  proxyVendor = true;

  postPatch = ''
    # Patch test that relies on looking up homedir in user struct to prefer ~
    substituteInPlace pkg/steampipeconfig/shared_test.go \
      --replace-fail 'filehelpers "github.com/turbot/go-kit/files"' "" \
      --replace-fail 'filepaths.SteampipeDir, _ = filehelpers.Tildefy("~/.steampipe")' 'filepaths.SteampipeDir = "~/.steampipe"';
  '';

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  checkFlags =
    let
      skippedTests = [
        # panic: could not create backups directory: mkdir /var/empty/.steampipe: operation not permitted
        "TestTrimBackups"
        # Skip tests that require network access
        "TestIsPortBindable"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    wrapProgram $out/bin/steampipe \
      --set-default STEAMPIPE_UPDATE_CHECK false \
      --set-default STEAMPIPE_TELEMETRY none

    INSTALL_DIR=$(mktemp -d)
    installShellCompletion --cmd steampipe \
      --bash <($out/bin/steampipe --install-dir $INSTALL_DIR completion bash) \
      --fish <($out/bin/steampipe --install-dir $INSTALL_DIR completion fish) \
      --zsh <($out/bin/steampipe --install-dir $INSTALL_DIR completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe steampipe} --version";
      package = steampipe;
      version = "v${version}";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/turbot/steampipe/blob/v${version}/CHANGELOG.md";
    description = "Dynamically query your cloud, code, logs & more with SQL";
    homepage = "https://steampipe.io/";
    license = lib.licenses.agpl3Only;
    mainProgram = "steampipe";
    maintainers = with lib.maintainers; [ hardselius anthonyroussel ];
  };
}
