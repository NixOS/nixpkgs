{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nomad-driver-podman";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qHhdjWc9bxUpHYUFUrupjtxxIVQDP43OeKKsCDa+4/M=";
  };

  vendorHash = "sha256-UIUavFdBuSiaUsNaibPjRMURMLLK5UjNHVoyNSIRNQ4=";

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
