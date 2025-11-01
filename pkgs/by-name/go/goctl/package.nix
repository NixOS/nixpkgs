{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goctl";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "zeromicro";
    repo = "go-zero";
    tag = "v${version}";
    hash = "sha256-wS8Hb0sqP2iPjF3EgkmmsE6aHpyiRw4kcYpDPmJvpic=";
  };

  vendorHash = "sha256-HTLpgrKDm+Sw7Y5VV13kitqF6mn479JxQbCAFMy0tTU=";

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
