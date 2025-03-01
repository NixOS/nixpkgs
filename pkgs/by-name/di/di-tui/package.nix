{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "di-tui";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "acaloiaro";
    repo = "di-tui";
    rev = "v${version}";
    hash = "sha256-jX+2wdnkJPEtCWoMNbwgn3c+LsEktYa5lIfSXY0Wsew=";
  };

  vendorHash = "sha256-b7dG0nSjPQpjWUbOlIxWudPZWKqtq96sQaJxKvsQT9I=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple terminal UI player for di.fm";
    homepage = "https://github.com/acaloiaro/di-tui";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.acaloiaro ];
    mainProgram = "di-tui";
  };
}
