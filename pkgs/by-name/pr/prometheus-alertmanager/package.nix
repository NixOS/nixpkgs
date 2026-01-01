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
<<<<<<< HEAD
  version = "0.30.0";
=======
  version = "0.29.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-103Jb2CA/Zz+MBIJei3vhqcPyg7e5JkpFKqh1hjAhLc=";
  };

  vendorHash = "sha256-LgGsXaJ97uXtqHHicsLOaMNx3PzlVPhz/xG+KvO4nLI=";
=======
    hash = "sha256-2uP4JCbQEe7/en5sBq/k73kqK6YVmuLvfiUy1fqPitw=";
  };

  vendorHash = "sha256-bN1iV2JrrjwiiIXr5lp389HvEoQGteJQD94cug0/048=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    changelog = "https://github.com/prometheus/alertmanager/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "alertmanager";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    changelog = "https://github.com/prometheus/alertmanager/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.asl20;
    mainProgram = "alertmanager";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      benley
      fpletz
      globin
      Frostman
    ];
  };
})
