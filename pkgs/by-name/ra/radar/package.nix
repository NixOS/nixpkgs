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
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "skyhook-io";
    repo = "radar";
    tag = "v${version}";
    hash = "sha256-lZwtAvNlmLusJVGNzjL1Zag4iU+VrOHp09xmWSq/JBI=";
  };

  frontend = buildNpmPackage {
    pname = "radar-web";
    inherit version src;

    npmDepsHash = "sha256-jP1pTa/L48VeFsKndyTkVnYB5cuEGMb0GpnHTXyAC0U=";
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

  vendorHash = "sha256-O+KQq6wYByyZ3toXO9axWKmae6qcCVovNFpbqNFTUr4=";

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
