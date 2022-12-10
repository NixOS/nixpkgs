{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2022-12-02";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "870e2e51feb2186bcb4c719e17967eb1311678a3";
    sha256 = "sha256-YWEgA1KAa1cj2YaqOXVVBw70gSxK7WEMNDyGJOFq4DQ=";
  };

  vendorSha256 = "sha256-+78Ln8179MfDKSfT/jnN9Y5CIbpdq28XMDHsIu+4f4c=";

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
