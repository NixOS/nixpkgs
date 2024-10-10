{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubo-migrator";
  version = "2.0.2-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "fs-repo-migrations";
    rev = "cbc31a03fb2f6aba80d577224c09472101427771";
    hash = "sha256-wgWwDuL5Yv7dSYFrBiC4OS7SuTHh1D8RSabBnOTUiZ0=";
    sparseCheckout = [ "fs-repo-migrations" ];
  };

  sourceRoot = "${src.name}/fs-repo-migrations";

  vendorHash = "sha256-/DqkBBtR/nU8gk3TFqNKY5zQU6BFMc3N8Ti+38mi/jk=";

  doCheck = false;

  meta = {
    description = "Run the appripriate migrations for migrating the filesystem repository of Kubo (migrations not included)";
    homepage = "https://github.com/ipfs/fs-repo-migrations";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      Luflosi
      elitak
    ];
    mainProgram = "fs-repo-migrations";
  };
}
