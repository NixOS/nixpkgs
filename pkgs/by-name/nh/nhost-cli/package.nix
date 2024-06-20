{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nhost-cli";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "nhost";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-TYi0Cth4GWEIT9QRUC4z3Uwnh4EmywY+XCOM5oJP+4g=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=v${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/nhost
  '';

  meta = {
    description = "A tool for setting up a local development environment for Nhost";
    homepage = "https://github.com/nhost/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nhost";
  };
}
