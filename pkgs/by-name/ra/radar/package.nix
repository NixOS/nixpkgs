{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  buildNpmPackage,
}:
let
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "skyhook-io";
    repo = "radar";
    tag = "v${version}";
    hash = "sha256-b7iEptbf4KcBWO9nPfbfYWKJGsokT8Nnz7W4u6SRg24=";
  };

  webui = buildNpmPackage {
    pname = "radar-ui";
    inherit version src;
    sourceRoot = "${src.name}/web";
    npmDepsHash = "sha256-JzwUwVW1Mi3prP2ZVoL29G15V2F3Z8mGD3iO0DQFL3Q=";

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/
    '';
  };
in

buildGoModule (finalAttrs: {
  pname = "radar";
  inherit version src;

  vendorHash = "sha256-q/+MZrrY9QPh+yYK5UKXOwXloB3IqEUHGVwd6+yp+3s=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    mkdir -p internal/static/dist
    cp -r ${webui}/share/dist/* internal/static/dist
  '';

  postInstall = ''
    mv $out/bin/explorer $out/bin/${finalAttrs.meta.mainProgram}
    # Create a symbolic link to the binary under the name `kubectl-radar`
    # to make it detectable as a kubectl plugin. This is also done in the official install script ${src}/install.sh
    ln -s $out/bin/${finalAttrs.meta.mainProgram} $out/bin/kubectl-radar
  '';

  doInstallCheck = true;
  nativeInstallHooks = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern Kubernetes visibility. Topology, event timeline, and service traffic — plus resource browsing and Helm management";
    homepage = "https://github.com/skyhook-io/radar";
    changelog = "https://github.com/skyhook-io/radar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "radar";
  };
})
