{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-chrony-exporter";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "superq";
    repo = "chrony_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YQmJ2MMvebrZUVzVGQxlDuUIEs0xRfKxcqH6iRHoY0k=";
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

  vendorHash = "sha256-WxYsvKIdAorBe0tFWpp8mfRfgdFjoxw1OSkwfB0MArg=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/chrony_exporter";
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/superq/chrony_exporter/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/superq/chrony";
    description = "Prometheus exporter for the chrony NTP service";
    license = lib.licenses.asl20;
    mainProgram = "chrony_exporter";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
