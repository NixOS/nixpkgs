{
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "di-tui";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "acaloiaro";
    repo = "di-tui";
    tag = "v${version}";
    hash = "sha256-jX+2wdnkJPEtCWoMNbwgn3c+LsEktYa5lIfSXY0Wsew=";
  };

  vendorHash = "sha256-b7dG0nSjPQpjWUbOlIxWudPZWKqtq96sQaJxKvsQT9I=";

  passthru.updateScript = pkgs.nix-update-script { };

  meta = {
    description = "Simple terminal UI player for di.fm";
    homepage = "https://github.com/acaloiaro/di-tui";
    license = licenses.bsd2;
    maintainers = [ maintainers.acaloiaro ];
    mainProgram = "di-tui";
  };
}
