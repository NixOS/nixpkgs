{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "exercism";
  version = "3.5.4";

  src = fetchFromGitHub {
    owner = "exercism";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-7euitdo/rdeopnP7hHHxQ5lPh8wJVDaTneckeR5BEGo=";
  };

  vendorHash = "sha256-xY3C3emqtPIKyxIN9aEkrLXhTxWNmo0EJXNZVtbtIvs=";

  doCheck = false;

  subPackages = [ "./exercism" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Go based command line tool for exercism.io";
    license = licenses.mit;
    maintainers = [
      maintainers.rbasso
      maintainers.nobbz
    ];
    mainProgram = "exercism";
  };
}
