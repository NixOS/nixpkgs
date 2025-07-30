{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "scion-bootstrapper";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "netsec-ethz";
    repo = "bootstrapper";
    rev = "v${version}";
    hash = "sha256-X4lNgd6klIw0NW9NVG+d1JK+WNfOclbu43GYucelB7o=";
  };

  vendorHash = "sha256-X4bOIvNlyQoAWOd3L6suE64KnlCV6kuE1ieVecVYWOw=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/bootstrapper $out/bin/scion-bootstrapper
  '';

  meta = with lib; {
    description = "Bootstrapper for SCION network configuration";
    homepage = "https://github.com/netsec-ethz/bootstrapper";
    license = licenses.asl20;
    maintainers = with maintainers; [
      matthewcroughan
      sarcasticadmin
    ];
    mainProgram = "scion-bootstrapper";
  };
}
