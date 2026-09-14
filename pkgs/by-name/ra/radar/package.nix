{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "skyhook-io";
    repo = "radar";
    tag = "v${version}";
    hash = "sha256-/zOSrk9Ez2dCb7AwyUsGbGOUizl1HgrkEFQdpguiEQs=";
  };

  frontend = buildNpmPackage {
    pname = "radar-web";
    inherit version src;

    npmDepsHash = "sha256-Zh+2zV4pmFPAgQPa5/tc3OdC/f2ahzXHNHiOxkKRB/A=";
    npmDepsFetcherVersion = 2;

    npmWorkspace = "web";

    installPhase = ''
      runHook preInstall
      cp -r web/dist "$out"
      runHook postInstall
    '';
  };
in
buildGoModule (finalAttrs: {
  pname = "radar";
  inherit version src;

  __structuredAttrs = true;

  vendorHash = "sha256-2NfovVO4nKKoSEM8vaekLwPVW90unP5chSNtCXBU80k=";

  subPackages = [ "cmd/explorer" ];

  preBuild = ''
    cp -r ${frontend}/. internal/static/dist/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # The httptest-based tests need to bind a loopback listener, which the Darwin
  # sandbox denies by default ("bind: operation not permitted").
  __darwinAllowLocalNetworking = true;

  checkFlags = [
    # Writes a `#!/bin/sh` helper to a temp dir and execs it, but the sandbox
    # provides no /bin/sh.
    "-skip=^TestDiagnoseStream_ProcessAndStreamErrors$"
  ];

  checkPhase = ''
    runHook preCheck
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    go test "''${checkFlags[@]}" ./...
    runHook postCheck
  '';

  postInstall = ''
    mv "$out/bin/explorer" "$out/bin/kubectl-radar"
  '';

  versionCheckProgramArg = [ "-version" ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    inherit frontend;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Local-first Kubernetes visibility: topology, event timeline, and service traffic";
    mainProgram = "kubectl-radar";
    homepage = "https://github.com/skyhook-io/radar";
    changelog = "https://github.com/skyhook-io/radar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.gaupee ];
    platforms = lib.platforms.unix;
  };
})
