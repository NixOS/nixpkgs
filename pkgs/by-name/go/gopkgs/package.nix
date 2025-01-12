{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopkgs";
  version = "2.1.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "uudashr";
    repo = "gopkgs";
    hash = "sha256-ll5fhwzzCNL0UtMLNSGOY6Yyy0EqI8OZ1iqWad4KU8k=";
  };

  vendorHash = "sha256-WVikDxf79nEahKRn4Gw7Pv8AULQXW+RXGoA3ihBhmt8=";

  subPackages = [ "cmd/gopkgs" ];

  doCheck = false;

  meta = {
    description = "Tool to get list available Go packages";
    mainProgram = "gopkgs";
    homepage = "https://github.com/uudashr/gopkgs";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.mit;
  };
}
