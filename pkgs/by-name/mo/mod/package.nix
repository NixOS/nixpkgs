{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "mod";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = "mod";
    rev = "v${version}";
    sha256 = "sha256-P0FE0Sl4IXH6DAETnlBwQ2CR0X0AP9Z0noW99By7mxU=";
  };

  vendorHash = "sha256-GiE2RNAxbKpIekn54bfYlNvIcQo8D3ysmPSvxQhujYI=";

  doCheck = false;

  subPackages = [ "cmd/mod" ];

  meta = with lib; {
    description = "Automated Semantic Import Versioning Upgrades for Go";
    mainProgram = "mod";
    longDescription = ''
      Command line tool to upgrade/downgrade Semantic Import Versioning in Go
      Modules.
    '';
    homepage = "https://github.com/marwan-at-work/mod";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
