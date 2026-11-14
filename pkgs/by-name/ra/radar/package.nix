{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  coreutils,
  runtimeShell,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "skyhook-io";
    repo = "radar";
    tag = "v${version}";
    hash = "sha256-QspUiCQXun+e/uBn/ortXwIN/G1omi4HZ11MjOm2tdU=";
  };

  frontend = buildNpmPackage {
    pname = "radar-web";
    inherit version src;

    npmDepsHash = "sha256-JX2Zzz2Lbwp5Td2EjR3o4SFfBWf2ulvA0d03LJG5zf4=";
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

  vendorHash = "sha256-hO1eNsT7GytccPr9mI3ZXihe3Es1jzml/Gmx/FOhDas=";

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

  # The claude agent is started with $HOME as its working directory.
  preCheck = ''
    export HOME="$(mktemp -d)"
    substituteInPlace internal/ai/{agent_cursor,diagnoser,lookup_unix}_test.go \
      --replace-quiet "#!/bin/sh" "#!${runtimeShell}" \
      --replace-quiet "#!/usr/bin/env" "#!${lib.getExe' coreutils "env"}"
    # Walks the source tree for port-forward call sites, including our vendor/.
    substituteInPlace internal/portforward/callsites_test.go \
      --replace-fail 'name == "packages"' 'name == "packages" || name == "vendor"'
  '';

  checkFlags = [
    # Flaky under load: the blocker check runs against an 80ms time budget.
    "-skip=^TestWaitUnschedulableJobPointsAtThePod$"
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

  # The config path is resolved from $HOME before -version is handled.
  preInstallCheck = ''
    export HOME="$(mktemp -d)"
  '';
  versionCheckKeepEnvironment = [ "HOME" ];
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
