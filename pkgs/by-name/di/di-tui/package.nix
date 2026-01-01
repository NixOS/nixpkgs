{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "di-tui";
<<<<<<< HEAD
  version = "1.13.2";
=======
  version = "1.11.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "acaloiaro";
    repo = "di-tui";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8aNwEDxaNUS909gRZ1PGEIKHIK8NmlxM6zwvc2xBlzc=";
=======
    hash = "sha256-CTZ98EbOdM/uCFZHtCGnU4OHmFw4iPwqseb0RuJvDnk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-b7dG0nSjPQpjWUbOlIxWudPZWKqtq96sQaJxKvsQT9I=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple terminal UI player for di.fm";
    homepage = "https://github.com/acaloiaro/di-tui";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.acaloiaro ];
    mainProgram = "di-tui";
  };
}
