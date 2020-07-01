{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "cni";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = pname;
    rev = "v${version}";
    sha256 = "02qn1br8164d99978acalisy1sx294g1axnii4yh1wji0fc735xz";
  };

  goPackagePath = "github.com/containernetworking/cni";

  meta = with lib; {
    description = "Container Network Interface - networking for Linux containers";
    license = licenses.asl20;
    homepage = "https://github.com/containernetworking/cni";
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = [ "x86_64-linux" ];
  };
}
