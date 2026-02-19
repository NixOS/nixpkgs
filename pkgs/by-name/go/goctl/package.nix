{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goctl";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "zeromicro";
    repo = "go-zero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3EhxeN2J8xgzMrqgpts2fVrVWZBoGFPVh/DAxc4r6Vc=";
  };

  vendorHash = "sha256-WS9fC4pDCNsc2mQPiMk/eHYqG+tF+/J/6RaMYM0/ql0=";

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
})
