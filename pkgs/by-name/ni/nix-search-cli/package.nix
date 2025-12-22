{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "nix-search-cli";
  version = "v0.3+commit.8ecb614";

  src = fetchFromGitHub {
    owner = "peterldowns";
    repo = "nix-search-cli";
    rev = "8ecb6143a2bb95e44d0d1357e4387923b79ef51d";
    hash = "sha256-CoPshsDV1kHGKF5aEc/VOGjf8aNLnTYx2sO3jK+5bhE=";
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
