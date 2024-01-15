{ lib
, buildGoModule
, fetchFromGitHub
, unstableGitUpdater
}:

buildGoModule {
  pname = "nix-search-cli";
  version = "unstable-2023-09-12";

  src = fetchFromGitHub {
    owner = "peterldowns";
    repo = "nix-search-cli";
    rev = "f3f1c53c72dadac06472a7112aeb486ab5dda695";
    hash = "sha256-YM1Lf7py79rU8aJE0PfQaMr5JWx5J1covUf1aCjRkc8=";
  };

  vendorHash = "sha256-JDOu7YdX9ztMZt0EFAMz++gD7n+Mn1VOe5g6XwrgS5M=";

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "CLI for searching packages on search.nixos.org";
    homepage = "https://github.com/peterldowns/nix-search-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
    platforms = platforms.all;
    mainProgram = "nix-search";
  };
}
