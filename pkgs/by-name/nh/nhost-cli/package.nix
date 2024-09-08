{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nhost-cli";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "nhost";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Xia45kNblGmU4i/CIHg/WOK3EJP1VUHenvLA4CGOY0U=";
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
