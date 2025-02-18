{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubexit";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "karlkfi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Kzom+/Xad6SI9czw4xvmTbJ+bNB9mF2oSq37IFn384U=";
  };

  vendorHash = "sha256-RA3+S5Pad+4mNUgcZ2Z0K0FKA3Za5o1ko049GM4yQQ8=";
  ldflags = [
    "-s"
    "-w"
  ];
  meta = with lib; {
    description = "Command supervisor for coordinated Kubernetes pod container termination";
    mainProgram = "kubexit";
    homepage = "https://github.com/karlkfi/kubexit/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
