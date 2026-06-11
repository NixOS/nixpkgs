{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "skyhook-io";
    repo = "radar";
    tag = "v${version}";
    hash = "sha256-oPWdG1K0cHgFstzKV5XUkhZr9WRGmmgM8bxS4xaXbgE=";
  };

  frontend = buildNpmPackage {
    pname = "radar-web";
    inherit version src;

    npmDepsHash = "sha256-2UUS7IAUz4SrZZcu23ERewZIlI3N8yG3Ji5xouQPf5U=";
    npmDepsFetcherVersion = 3;

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

  vendorHash = "sha256-zjTNroU7jwaoZ+UObtEcxYeGk1EHUy6+jRC4OrphOE8=";

  subPackages = [ "cmd/explorer" ];

  preBuild = ''
    cp -r ${frontend}/. internal/static/dist/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # `subPackages` restricts the default checkPhase to cmd/explorer, so run the
  # whole test suite explicitly. The e2e tests are gated behind a build tag and
  # are skipped here.
  checkPhase = ''
    runHook preCheck
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    go test ./...
    runHook postCheck
  '';

  postInstall = ''
    mv "$out/bin/explorer" "$out/bin/kubectl-radar"
  '';

  versionCheckProgramArg = [ "version" ];
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
