{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gvproxy";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "gvisor-tap-vsock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wwQ4Wf9KtXwYTpoCUMuMUpTQBPlgynGe/VFqP/79xUA=";
  };

  vendorHash = null;

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install bin/* -Dt $out/bin
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/containers/gvisor-tap-vsock/releases/tag/${finalAttrs.src.rev}";
    description = "Network stack based on gVisor";
    homepage = "https://github.com/containers/gvisor-tap-vsock";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
  };
})
