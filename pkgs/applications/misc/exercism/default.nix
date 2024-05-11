{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

buildGoModule rec {
  pname = "exercism";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "exercism";
    repo  = "cli";
    rev   = "refs/tags/v${version}";
    hash  = "sha256-+Tg9b7JZtriF5b+mnLgOeTTLiswH/dSGg3Mj1TBt4Wk=";
  };

  vendorHash = "sha256-xY3C3emqtPIKyxIN9aEkrLXhTxWNmo0EJXNZVtbtIvs=";

  doCheck = false;

  subPackages = [ "./exercism" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso maintainers.nobbz ];
   mainProgram = "exercism";
  };
}
