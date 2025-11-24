{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goctl";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "zeromicro";
    repo = "go-zero";
    tag = "v${version}";
    hash = "sha256-Q5fRu7EKCPlO6yxEe/GWs4zam7MnomYJn9u0BZqDMy4=";
  };

  vendorHash = "sha256-wAQF2twQSKD8rxBchU/L4o8Z5noGK/ITAelUAHMj5gg=";

  modRoot = "tools/goctl";
  subPackages = [ "." ];

  doCheck = true;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI handcuffle of go-zero, a cloud-native Go microservices framework";
    longDescription = ''
      goctl is a go-zero's built-in handcuffle that is a major
      lever to increase development efficiency, generating code,
      document, deploying k8s yaml, dockerfile, etc.
    '';
    homepage = "https://go-zero.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cococolanosugar ];
    mainProgram = "goctl";
  };
}
