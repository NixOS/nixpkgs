{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kbld";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kbld";
    rev = "v${version}";
    hash = "sha256-3QLvUvm1OBLGS8ucFEDDLVupwof8ToG0RBJpUPtqThE=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kbld" ];

  env.CGO_ENABLED = 0;

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
