{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2021-12-14";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "8091752a67781273944e7a79a803b7a671378313";
    sha256 = "sha256-tZp0ra/Sq/5MAFlAFHPJ94jYxtHbDiG1wSD4NOH1x7I=";
  };

  vendorSha256 = "sha256-xkJh7k8GZmoZqE0HgbFp2xMJQOVDkPEXOZEl6bJZz1A=";

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
