{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "limesctl";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2eB+VpMrhzs0Dg+X1sf7TVW7uK/URETUuWO82jQl57k=";
  };

  vendorSha256 = "sha256-VKxwdlyQUYmxubl4Y2uKvekuHd62GcGaoPeUBC+lcJU=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
