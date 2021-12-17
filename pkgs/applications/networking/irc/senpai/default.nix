{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2021-11-29";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "3904c9190d94f273c0ae9937d3161b9fe4adf856";
    sha256 = "sha256-4ZhJuAxcoGjRO5xVqzlmaUvipnyiFMuJ1A3n8vlhYxU=";
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
