{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "helm-docs";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "norwoodj";
    repo = "helm-docs";
    rev = "v${version}";
    hash = "sha256-lSGgT+aWp4NgiIoCnR4TNdecEqIZVnKMmGtEingq05o=";
  };

  vendorHash = "sha256-LpARmDupT+vUPqUwFnvOGKOaBQbTuTvQnWc5Q2bGBaY=";

  subPackages = [ "cmd/helm-docs" ];
  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/norwoodj/helm-docs";
    description = "A tool for automatically generating markdown documentation for Helm charts";
    mainProgram = "helm-docs";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
