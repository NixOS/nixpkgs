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

buildGoModule rec {
  pname = "powerpipe";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "powerpipe";
    tag = "v${version}";
    hash = "sha256-q9wIpjYtVBkCDKf5njxpnGzVV8n5rqIrcsfH/J59mhg=";
  };

  vendorHash = "sha256-s1P/M6xh0LWnrgt8fo58udfqiA8IyWFl0mI0FmKOYCc=";
  proxyVendor = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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
      version = "v${version}";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/turbot/powerpipe/blob/v${version}/CHANGELOG.md";
    description = "Dynamically query your cloud, code, logs & more with SQL";
    homepage = "https://powerpipe.io/";
    license = lib.licenses.agpl3Only;
    mainProgram = "powerpipe";
    maintainers = with lib.maintainers; [ weitzj ];
  };
}
