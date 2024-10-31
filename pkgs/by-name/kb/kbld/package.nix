{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kbld";
  version = "0.44.1";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kbld";
    rev = "v${version}";
    hash = "sha256-sEzCA32r3nSY1hT1r4EPPWsF9Kgn0rXnaAKlatFjZIo=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kbld" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-X=carvel.dev/kbld/pkg/kbld/version.Version=${version}"
  ];

  meta = {
    description = "Seamlessly incorporates image building and image pushing into your development and deployment workflows";
    homepage = "https://carvel.dev/kbld/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benchand ];
    mainProgram = "kbld";
  };
}
