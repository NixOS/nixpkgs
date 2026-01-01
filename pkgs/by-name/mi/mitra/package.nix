{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitra";
<<<<<<< HEAD
  version = "4.15.0";
=======
  version = "4.14.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "silverpill";
    repo = "mitra";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zEJ+fGOY69F/gF7ZFyWigAxTXP6sZMvFo7sgy36wVFk=";
  };

  cargoHash = "sha256-DQAqvh17AWQt3gSRzQlP5ZL3L1Euqsl+bXoiJBGkdqo=";
=======
    hash = "sha256-LYtiavRgWEH9wFLfnS4xPuZmwSBatPbzDEc3qn2rrBM=";
  };

  cargoHash = "sha256-NXPhc1c8JYjAPcQfVobOQten1czD77KLpBqwyEC3AuQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # require running database
  doCheck = false;

  RUSTFLAGS = [
    # MEMO: mitra use ammonia crate with unstable rustc flag
    "--cfg=ammonia_unstable"
  ];

  buildFeatures = [
    "production"
  ];

  meta = {
    description = "Federated micro-blogging platform";
    homepage = "https://codeberg.org/silverpill/mitra";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "mitra";
  };
}
