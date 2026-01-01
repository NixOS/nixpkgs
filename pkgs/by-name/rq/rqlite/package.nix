{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rqlite";
<<<<<<< HEAD
  version = "9.3.5";
=======
  version = "9.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = "rqlite";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-JYFTFIPtLNbYhv+ITWEm7ZBJrOBHc/wynxy74uouA2c=";
  };

  vendorHash = "sha256-9KaBRiuNQGTcx8Gc8wPy6bj5d6pFKsLS87nsDwWet0o=";
=======
    hash = "sha256-35wW/on76G51/U/9DTyeXKIxPsYZiISIHBDSeUCM/A4=";
  };

  vendorHash = "sha256-ieJ5D5CPMPVyPGvMx6suiaj9ah4i1bDzAxHQtRDDYWo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [
    "cmd/rqlite"
    "cmd/rqlited"
    "cmd/rqbench"
  ];

  # Leaving other flags from https://github.com/rqlite/rqlite/blob/master/package.sh
  # since automatically retrieving those is nontrivial and inessential
  ldflags = [
    "-s"
    "-w"
    "-X github.com/rqlite/rqlite/cmd.Version=${finalAttrs.version}"
  ];

  # Tests are in a different subPackage which fails trying to access the network
  doCheck = false;

  meta = {
    description = "Lightweight, distributed relational database built on SQLite";
    homepage = "https://github.com/rqlite/rqlite";
    changelog = "https://github.com/rqlite/rqlite/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
