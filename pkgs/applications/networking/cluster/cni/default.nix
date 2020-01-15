{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "cni";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = pname;
    rev = "v${version}";
    sha256 = "15ad323dw44k82bfx9r8w5q2kn7jix60p9v4ciyzx2p5pip36wp8";
  };

  goPackagePath = "github.com/containernetworking/cni";
  meta = with stdenv.lib; {
    description = "Container Network Interface - networking for Linux containers";
    license = licenses.asl20;
    homepage = https://github.com/containernetworking/cni;
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = [ "x86_64-linux" ];
  };
}
