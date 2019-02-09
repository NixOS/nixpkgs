{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kube-router-${version}";
  version = "0.2.5";
  rev = "v${version}";

  goPackagePath = "github.com/cloudnativelabs/kube-router";

  src = fetchFromGitHub {
    inherit rev;
    owner = "cloudnativelabs";
    repo = "kube-router";
    sha256 = "1j6q6kg4qj75v2mdy9ivvwq8mx9fpdf0w08959l8imrp5byd56wv";
  };

  buildFlagsArray = ''
    -ldflags=
    -X
    ${goPackagePath}/pkg/cmd.version=${version}
    -X
    ${goPackagePath}/pkg/cmd.buildDate=Nix
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens johanot ];
    platforms = platforms.linux;
  };
}
