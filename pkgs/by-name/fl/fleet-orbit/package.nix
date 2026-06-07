{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fleet-orbit";
  version = "1.55.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "orbit-v${finalAttrs.version}";
    hash = "sha256-gaS6A9Zfpb/VMQMAO5qI0lIaohD8jj4KWFRTU0OeqMo=";
  };

  vendorHash = "sha256-fhACxmzJY0PEQmMbjQxlfQh5ZJ+7a4um0s8xFQq+57w=";

  env.CGO_ENABLED = "1";

  subPackages = [ "orbit/cmd/orbit" ];

  goFlags = [ "-buildvcs=false" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Version=${finalAttrs.version}"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Commit=0000000000000000000000000000000000000000"
    "-X=github.com/fleetdm/fleet/v4/orbit/pkg/build.Date=1970-01-01T00:00:00Z"
  ];

  patches = [
    ./0001-orbit-nixos.patch
    ./0002-osqueryd-path-override.patch
    ./0003-osquery-log-path.patch
    ./0004-scripts-nixos.patch
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests = {
    inherit (nixosTests) orbit;
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
    maintainers = with lib.maintainers; [ adrielvelazquez ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
