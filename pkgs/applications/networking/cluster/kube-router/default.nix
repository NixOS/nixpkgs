{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kube-router";
  version = "1.0.0";

  goPackagePath = "github.com/cloudnativelabs/kube-router";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b6rsiq3pwp7wknmblgd8kszh9bd7nhvlsnyyamqnhlfjl97929x";
  };

  buildFlagsArray = ''
    -ldflags=
    -X
    ${goPackagePath}/pkg/cmd.version=${version}
    -X
    ${goPackagePath}/pkg/cmd.buildDate=Nix
  '';

  meta = with lib; {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens johanot ];
    platforms = platforms.linux;
  };
}
