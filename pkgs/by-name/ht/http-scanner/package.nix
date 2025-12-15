{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "http-scanner";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "aymaneallaoui";
    repo = "kafka-http-scanner";
    tag = version;
    hash = "sha256-+8UpdNRuu0nTYiBBS+yiVwDEtC/KpEeyPCEeJvsjxfs=";
  };

  vendorHash = "sha256-Nvp9Qd1lz6/4fTgvqpInk+QhKYr/Fcunw53WERBpT8Q=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aymaneallaoui/kafka-http-scanner/pkg/utils.Version=${version}"
  ];

  meta = {
    description = "HTTP security vulnerability scanner that detects a wide range of web application vulnerabilities";
    homepage = "https://github.com/aymaneallaoui/kafka-http-scanner";
    changelog = "https://github.com/aymaneallaoui/kafka-http-scanner/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "http-scanner";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
