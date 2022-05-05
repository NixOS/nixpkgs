{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2022-04-29";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "859b8fdb7d433a848668c6f1a00406f107fe00e5";
    sha256 = "sha256-grVv/bcUEU6Aaf+4MbkocY/75u7q6Q7r26xK0ybULUg=";
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
