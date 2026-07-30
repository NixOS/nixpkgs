{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "nix-search-cli";
  version = "0.3-unstable-2025-12-03";

  src = fetchFromGitHub {
    owner = "peterldowns";
    repo = "nix-search-cli";
    rev = "ab0d5156c1e3b383c250ff273639cd3dea6de2d9";
    hash = "sha256-NGL9jj4y16+d0Es7aK1oxqAimZn7sdJDAxVkcY3CTcg=";
  };

  vendorHash = "sha256-VlJ2OuHOTqIJeGUm2NbBiz33i8QTxaZnnm0JkVGkw1U=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "CLI for searching packages on search.nixos.org";
    homepage = "https://github.com/peterldowns/nix-search-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.all;
    mainProgram = "nix-search";
  };
}
