{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2023-01-03";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "5414edb01f30ad9480e211030db1bcd858e5f741";
    sha256 = "sha256-GsdU+IBuHhwt8n4SEMCUSUzLQezwVtZ9L/0uF5aculA=";
  };

  vendorSha256 = "sha256-PkoEHQEGKCiNbJsm7ieL65MtEult/wubLreJKA1gGpg=";

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
