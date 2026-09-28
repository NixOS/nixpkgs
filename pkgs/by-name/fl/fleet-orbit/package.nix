{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "fleet-orbit";
  version = "1.63.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    rev = "5e2f9163460ac8246bbace9192bcb99e8a2989e3";
    hash = "sha256-cKF1nE9kK22EfB0Ky+vp8QaBDYcZ00mwWNU9BJwWAx8=";
  };

  vendorHash = "sha256-mnjllTf4m8Kirx0TKKWzr0haA/zwiZMWYEYRifVeFpQ=";

  env.CGO_ENABLED = "1";

  subPackages = [ "orbit/cmd/orbit" ];

  goFlags = [ "-buildvcs=false" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Version=${finalAttrs.version}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Commit=${finalAttrs.src.rev}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Date=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [ versionCheckHook ];
  postInstallCheck = ''
    "$out/bin/orbit" version | grep -Fqx "commit - ${finalAttrs.src.rev}"
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^orbit-v([0-9.]+)$" ];
    };

    tests = {
      inherit (nixosTests) orbit;
    };
  };

  meta = {
    description = "Fleet's lightweight osquery manager";
    homepage = "https://github.com/fleetdm/fleet";
    changelog = "https://github.com/fleetdm/fleet/releases/tag/orbit-v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      (lib.licenses.mkLicense {
        shortName = "fleet-ee";
        fullName = "Fleet Enterprise Edition License";
        url = "https://github.com/fleetdm/fleet/blob/${finalAttrs.src.rev}/ee/LICENSE";
        free = false;
      })
    ];
    mainProgram = "orbit";
    maintainers = with lib.maintainers; [
      adrielvelazquez
      faukah
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
