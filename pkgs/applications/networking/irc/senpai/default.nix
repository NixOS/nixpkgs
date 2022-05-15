{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2022-05-10";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "7a9fe74fdfb3f334b97434df0aa74b2b32e3582e";
    sha256 = "sha256-uagdJG+YVryzsaZfkg5W2F8mQSc1bpflL77tqMHp1Ck=";
  };

  vendorSha256 = "sha256-hgojB1D0/SZWLEzJ48EBoT/InYYmqD/1qoTknfk/aTo=";

  subPackages = [
    "cmd/senpai"
  ];

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  postInstall = ''
    scdoc < doc/senpai.1.scd > doc/senpai.1
    scdoc < doc/senpai.5.scd > doc/senpai.5
    installManPage doc/senpai.*
  '';

  meta = with lib; {
    description = "Your everyday IRC student";
    homepage = "https://ellidri.org/senpai";
    license = licenses.isc;
    maintainers = with maintainers; [ malvo ];
  };
}
