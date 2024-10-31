{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "limesctl";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iWj/mielX4FbR+yjUykHj4zbTA6Is7NfEbbtqXV/obk=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "limesctl";
  };
}
