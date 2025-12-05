{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "alertmanager";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2uP4JCbQEe7/en5sBq/k73kqK6YVmuLvfiUy1fqPitw=";
  };

  vendorHash = "sha256-bN1iV2JrrjwiiIXr5lp389HvEoQGteJQD94cug0/048=";

  subPackages = [
    "cmd/alertmanager"
    "cmd/amtool"
  ];

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/amtool --completion-script-bash > amtool.bash
    installShellCompletion amtool.bash
    $out/bin/amtool --completion-script-zsh > amtool.zsh
    installShellCompletion amtool.zsh
  '';

  passthru.tests = { inherit (nixosTests.prometheus) alertmanager; };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    changelog = "https://github.com/prometheus/alertmanager/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.asl20;
    mainProgram = "alertmanager";
    maintainers = with maintainers; [
      benley
      fpletz
      globin
      Frostman
    ];
  };
})
