{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-example";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "seredot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7tqeIE6Ds8MrLH9k8cdzpeJP9pXVptduoEFE0zdrLlo=";
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
