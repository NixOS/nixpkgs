{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cadvisor";
  version = "0.61.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4pl6sN/BepCEo59VQ8x0ODBm1oRoWZ4Q1ayORXsFHZ4=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-ECLpq1vk2EqJo0DcKvCqLI7Bq3k8L8ji+wuC9It6jGw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/google/cadvisor/lib/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) cadvisor; };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(\\d+\\.\\d+\\.\\d+)"
      ];
    };
  };

  meta = {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    changelog = "https://github.com/google/cadvisor/releases/tag/v${finalAttrs.version}";
    mainProgram = "cadvisor";
    homepage = "https://github.com/google/cadvisor";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
    platforms = lib.platforms.linux;
  };
})
