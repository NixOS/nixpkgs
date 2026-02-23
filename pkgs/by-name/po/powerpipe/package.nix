{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeWrapper,
  nix-update-script,
  powerpipe,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "powerpipe";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "powerpipe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A8yn1HaWbgRtebjPKB7VIiehe3P1g8ua5PeVeUswSk0=";
  };

  vendorHash = "sha256-Rf9NlnnkM6V7ykvmc95PlEqYW8LKAbjVV6tZyZqyUDU=";
  proxyVendor = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = true;

  checkFlags =
    let
      skippedTests = [
        # test fails in the original github.com/turbot/powerpipe project as well
        "TestGetAsSnapshotPropertyMap/card"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    wrapProgram $out/bin/powerpipe \
      --set-default POWERPIPE_UPDATE_CHECK false \
      --set-default POWERPIPE_TELEMETRY none
  '';

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe powerpipe} --version";
      package = powerpipe;
      version = "v${finalAttrs.version}";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/turbot/powerpipe/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Dynamically query your cloud, code, logs & more with SQL";
    homepage = "https://powerpipe.io/";
    license = lib.licenses.agpl3Only;
    mainProgram = "powerpipe";
    maintainers = with lib.maintainers; [ weitzj ];
  };
})
