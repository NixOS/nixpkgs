{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aiac";
  version = "2.2.0";
  excludedPackages = [".ci"];

  src = fetchFromGitHub {
    owner = "gofireflyio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ju2LoCDY4lQaiJ3OSkt01SaOqVLrDGiTAwxxRnbnz/0=";
  };

  vendorHash = "sha256-UaC3Ez/i+kPQGOJYtCRtaD2pn3kVZPTaoCcNG7LiFbY=";
  ldflags = [ "-s" "-w" "-X github.com/gofireflyio/aiac/v3/libaiac.Version=v${version}" ];

  meta = with lib; {
    description = ''Artificial Intelligence Infrastructure-as-Code Generator.'';
    homepage = "https://github.com/gofireflyio/aiac/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
