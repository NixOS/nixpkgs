{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-example";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "seredot";
    repo = pname;
    rev = "v${version}";
    sha256 = "18vp53cda93qjssxygwqp55yc80a93781839gf3138awngf731yq";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "kubectl plugin for retrieving resource example YAMLs";
    homepage = "https://github.com/seredot/kubectl-example";
    changelog = "https://github.com/seredot/kubectl-example/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
