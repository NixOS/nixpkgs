{
  bash,
  lib,
  buildGoModule,
  coreutils,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  python3,
  systemd,
  versionCheckHook,
  zsh,
}:

buildGoModule (finalAttrs: {
  pname = "fleet-orbit";
  version = "1.59.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "orbit-v${finalAttrs.version}";
    hash = "sha256-JkEiq3V6VFKQYAxfD9YAmpJW978Hp52X5btrZpPjtxY=";
  };

  vendorHash = "sha256-FJtIK+SQNRpxTQdzPAFQCOy4dLNf7BfLru8Gm3ejtZM=";

  env.CGO_ENABLED = "1";

  subPackages = [ "orbit/cmd/orbit" ];

  goFlags = [ "-buildvcs=false" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Version=${finalAttrs.version}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Commit=0000000000000000000000000000000000000000"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Date=1970-01-01T00:00:00Z"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/scripts.scriptEnvPath=${lib.getExe' coreutils "env"}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/scripts.scriptShPath=${lib.getExe' bash "sh"}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/scripts.scriptBashPath=${lib.getExe' bash "bash"}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/scripts.scriptZshPath=${lib.getExe' zsh "zsh"}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/scripts.scriptPythonPath=${lib.getExe' python3 "python"}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/scripts.scriptPython3Path=${lib.getExe' python3 "python3"}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/user.loginctlPath=${lib.getExe' systemd "loginctl"}"
  ];

  patches = [
    ./0001-runtime-path-overrides.patch
    ./0002-script-interpreter-paths.patch
    ./0003-loginctl-path.patch
  ];

  checkPhase = ''
    runHook preCheck
    # Keep the package linker flags so interpreter-path tests exercise the
    # immutable paths embedded in the Orbit binary.
    export GOFLAGS=''${GOFLAGS//-trimpath/}

    buildGoDir test ./orbit/cmd/orbit
    buildGoDir test ./orbit/pkg/scripts
    buildGoDir test ./orbit/pkg/user

    runHook postCheck
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [ versionCheckHook ];

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
      {
        shortName = "fleet-ee";
        fullName = "Fleet Enterprise Edition License";
        url = "https://github.com/fleetdm/fleet/blob/orbit-v${finalAttrs.version}/ee/LICENSE";
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
