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
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "skyhook-io";
    repo = "radar";
    tag = "v${version}";
    hash = "sha256-ph5BlKowY4KFs7sbr41UoJKkVb7AbftdGE8uGYaJk2s=";
  };

  frontend = buildNpmPackage {
    pname = "radar-web";
    inherit version src;

    npmDepsHash = "sha256-rjYw5mveqCmxUoce4d/6gt3q9AlSxeSGpjuHsaWGAdk=";
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

  vendorHash = "sha256-GsOiggDPrTkDfh7JOmzTRr0oEigUSbH7WKPY5VVH8gU=";

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
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
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
