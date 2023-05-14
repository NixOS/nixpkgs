{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubo-migrator";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "fs-repo-migrations";
    # Use the latest git tag here, since v2.0.2 does not
    # contain the latest migration fs-repo-11-to-12/v1.0.2
    # The fs-repo-migrations code itself is the same between
    # the two versions but the migration code, which is built
    # into separate binaries, is not.
    rev = "fs-repo-12-to-13/v1.0.0";
    hash = "sha256-QQone7E2Be+jVfnrwqQ1Ny4jo6mSDHhaY3ErkNdn2f8=";
  };

  sourceRoot = "source/fs-repo-migrations";

  vendorHash = "sha256-/DqkBBtR/nU8gk3TFqNKY5zQU6BFMc3N8Ti+38mi/jk=";

  doCheck = false;

  meta = with lib; {
    description = "Migrations for the filesystem repository of Kubo clients";
    homepage = "https://github.com/ipfs/fs-repo-migrations";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi elitak ];
    mainProgram = "fs-repo-migrations";
  };
}
