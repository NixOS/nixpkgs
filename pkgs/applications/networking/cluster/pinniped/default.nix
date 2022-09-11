{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec{
  pname = "pinniped";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
    sha256 = "sha256-0h7zyKe2gmC1n9EB5FRVI/io7Yj+91ZAtLy+1u3gyO0=";
  };

  subPackages = "cmd/pinniped";

  vendorSha256 = "sha256-8ohyyciL1ORYOxPu64W0jXASTv+vVZR8StutzbF9N4Y=";

  meta = with lib; {
    description = "Tool to securely log in to your Kubernetes clusters";
    homepage = "https://pinniped.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bpaulin ];
  };
}
