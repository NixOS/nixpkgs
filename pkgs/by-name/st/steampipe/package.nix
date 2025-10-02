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
  version = "2.2.0";

  env.CGO_ENABLED = 0;

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe";
    tag = "v${version}";
    hash = "sha256-bYnwtGeFOtUfYzlx0o0jtfuyeItXU9LiO0fJy8UGv6k=";
  };

  vendorHash = "sha256-VHAbMgBISWWGhZBRl5JA0gytRSSdaFMCJUzMxmoNtPc=";
  proxyVendor = true;

  postPatch = ''
    # Patch test that relies on looking up homedir in user struct to prefer ~
    substituteInPlace pkg/steampipeconfig/shared_test.go \
      --replace-fail 'filehelpers "github.com/turbot/go-kit/files"' "" \
      --replace-fail 'app_specific.InstallDir, _ = filehelpers.Tildefy("~/.steampipe")' 'app_specific.InstallDir = "~/.steampipe"';
  '';

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=unknown"
    "-X main.builtBy=nixpkgs"
  ];

  doCheck = true;

  checkFlags =
    let
      skippedTests = [
        # panic: could not create backups directory: mkdir /var/empty/.steampipe: operation not permitted
        "TestTrimBackups"
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
    maintainers = with lib.maintainers; [
      hardselius
      anthonyroussel
    ];
  };
}
