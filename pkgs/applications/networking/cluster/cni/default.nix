{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "cni";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vxwNHIc3rFi7HKIEZrBcr7Oxs2iUtFYcfJK7aXDUv3k=";
  };

  goPackagePath = "github.com/containernetworking/cni";

  meta = with lib; {
    description = "Container Network Interface - networking for Linux containers";
    license = licenses.asl20;
    homepage = "https://github.com/containernetworking/cni";
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
