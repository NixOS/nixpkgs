{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-tibber-exporter";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "terjesannum";
    repo = "tibber-exporter";
    tag = "tibber-exporter-${finalAttrs.version}";
    hash = "sha256-by7/c2a/8jM4ShoeQnYC+L+EVLk2NwQoRTAMiZZcMn0=";
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

  vendorHash = "sha256-rjM2M9auiyFvGcq/D8N5YPoFOPeC9r1Y1JPssT7nvew=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "tibber-exporter-(.*)"
    ];
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/tibber-exporter";

  meta = {
    changelog = "https://github.com/terjesannum/tibber-exporter/releases/tag/tibber-exporter-${finalAttrs.version}";
    homepage = "https://github.com/terjesannum/tibber-exporter";
    description = "Prometheus exporter for tibber energy meter, pulse, watty and more";
    license = lib.licenses.mit;
    mainProgram = "tibber-exporter";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
