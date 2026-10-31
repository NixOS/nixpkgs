{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lazykube";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "TNK-Studio";
    repo = "lazykube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xfGzbjaH7dHeLWEaoRcYx5Gc3w4a4Kk1a1gG/EbXmSg=";
  };

  vendorHash = "sha256-3D+CElXHJv1WmBnO32hS4vW5VXXlNR3LwyGMtQJh3xs=";

  subPackages = [ "cmd/lazykube" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple terminal UI for managing Kubernetes";
    longDescription = ''
      lazykube is a terminal-based UI for Kubernetes that provides an easy way to
      browse and manage Kubernetes clusters with mouse and keyboard navigation.
    '';
    homepage = "https://github.com/TNK-Studio/lazykube";
    changelog = "https://github.com/TNK-Studio/lazykube/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "lazykube";
    platforms = lib.platforms.unix;
  };
})
