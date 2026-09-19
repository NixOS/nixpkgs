{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "rekor-tiles";
  version = "2.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "rekor-tiles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YbW6SKxVT+mwAa72bI+z3W6q8ck3H9yXGEFeSEB+2LM=";
  };
  vendorHash = "sha256-YVN9vFXyVuDAzjLw8vvyBXcY+aRf/uZ2uKKRRhm2bLE=";

  subPackages = [
    "cmd/rekor-server/aws"
    "cmd/rekor-server/gcp"
    "cmd/rekor-server/gcpcloudsql"
    "cmd/rekor-server/posix"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${finalAttrs.version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    for bin in aws gcp gcpcloudsql posix; do
      mv "$GOPATH/bin/$bin" "$out/bin/rekor-server-$bin"
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/rekor-server-gcp";
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "(v2) Signature Transparency Log designed for ease of use, low cost, and minimal maintenance.";
    homepage = "https://github.com/sigstore/rekor-tiles";
    changelog = "https://github.com/sigstore/rekor-tiles/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ andrewzah ];
  };
})
