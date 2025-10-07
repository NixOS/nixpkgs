{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goctl";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "zeromicro";
    repo = "go-zero";
    tag = "v${version}";
    hash = "sha256-iTkxfMzrKbSRMyG1VWV5VbnDNwpE9t+YQzmL6DwRGHQ=";
  };

  vendorHash = "sha256-rARM93I+m8I99Vdevd/v/h8CB+fQ+Abj4J//KOu6+Pc=";

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
