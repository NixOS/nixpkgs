{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-ai";
  version = "0.0.26";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubectl-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xWZcBTYPsVlv8pywQ12YDx2S3TQ0qXnRvoG5MAV4bdA=";
  };

  vendorHash = "sha256-LWOJhncRZ1f9I5BtPl4LPcEMWYhl8rZDk5pWDuO+2Nk=";

  # Build the main command
  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/{cmd,kubectl-ai}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    description = "AI powered Kubernetes Assistant";
    homepage = "https://github.com/GoogleCloudPlatform/kubectl-ai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "kubectl-ai";
  };
})
