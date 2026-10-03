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
  version = "1.61.0-unstable-2026-09-28";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    rev = "216d619f216758d373ec34958c144cb37c402230";
    hash = "sha256-ED0WO0i1hY6j6FKKrFogMGVIECJ4p12JmlCrkoBfSEQ=";
  };

  vendorHash = "sha256-WCbmlJBu4JUJ6SMtICViArR2YI9fzydoOJWC7fDacrU=";

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
    changelog = "https://github.com/fleetdm/fleet/pull/54098";
    license = with lib.licenses; [
      mit
      {
        shortName = "fleet-ee";
        fullName = "Fleet Enterprise Edition License";
        url = "https://github.com/fleetdm/fleet/blob/${finalAttrs.src.rev}/ee/LICENSE";
        free = false;
      }
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
