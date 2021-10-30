{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2021-05-27";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "6be718329175c6d11e359f1a366ab6ab22b101d2";
    sha256 = "sha256-hW6DHJlDBYEqK8zj5PvGKU54sbeXjx1tdqwKXPXlKHc=";
  };

  vendorSha256 = "sha256-OLi5y1hrYK6+l5WB1SX85QU4y3KjFyGaEzgbE6lnW2k=";

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
