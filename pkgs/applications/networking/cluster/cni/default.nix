{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "cni";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = pname;
    rev = "v${version}";
    sha256 = "16i59dhiq7pc7qs32cdk4yv4w9rjx4vvlw7fb6a6jhq6hxxjrgiw";
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
