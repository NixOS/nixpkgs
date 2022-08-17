{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "katafygio";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "bpineau";
    repo = "katafygio";
    rev = "v${version}";
    sha256 = "sha256-fRMXRKr620l7Y6uaYur3LbCGgLeSJ27zEGK0Zq7LZEY=";
  };

  vendorSha256 = "sha256-4hf6OueNHkReXdn9RuO4G4Zrpghp45YkuEwmci4wjz8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bpineau/katafygio/cmd.version=${version}"
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Dump, or continuously backup Kubernetes objects as yaml files in git";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
