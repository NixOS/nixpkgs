{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-ai";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubectl-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-64y8XiJ59pEvYMZzOVcepKxRffmijDWoO5A8ccWtsZY=";
  };

  vendorHash = "sha256-I3sObZNTH4w+1THOWPJDdtKPYeoQ8ULvSzyh+91pHNI=";

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
