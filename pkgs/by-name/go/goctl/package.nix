{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goctl";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "zeromicro";
    repo = "go-zero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fzvYlFIfFymQihyyD9z+kbhX279m3ZRIusKM/9fjXQY=";
  };

  vendorHash = "sha256-dLKcsCcODtAjMGpaGyogHk8z5e0ppJ3PoRF4NDs+Ye4=";

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
