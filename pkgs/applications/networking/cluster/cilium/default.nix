{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cilium-cli";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4+4E7v/b74DDekqymH8PR7/GfH3GGzSQFQk24VJisQ0=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium";
    license = licenses.asl20;
    homepage = "https://www.cilium.io/";
    maintainers = with maintainers; [ humancalico ];
    mainProgram = "cilium";
  };
}
