{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-tibber-exporter";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "terjesannum";
    repo = "tibber-exporter";
    tag = "tibber-exporter-${finalAttrs.version}";
    hash = "sha256-Ndg2BxWdL5DKa2eHjY0rIdrfJ+SJlzvOUZDtWUBSR6g=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/BUILD_COMMIT_DATE
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  # do not use real BuildDate, but fixed imagenary (commit date) for binary reproducibility
  preBuild = ''
    ldflags+=" -X github.com/prometheus/common/version.BuildDate=$(cat BUILD_COMMIT_DATE)"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Revision=${finalAttrs.src.rev}"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
  ];

  vendorHash = "sha256-JTJTapsqBj0FO2Gcx8O1eWJf9hMbeWzjtO0HYcDdzQo=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/tibber-exporter";
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/terjesannum/tibber-exporter/releases/tag/tibber-exporter-${finalAttrs.version}";
    homepage = "https://github.com/terjesannum/tibber-exporter";
    description = "Prometheus exporter for tibber energy meter, pulse, watty and more";
    license = lib.licenses.mit;
    mainProgram = "tibber-exporter";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
