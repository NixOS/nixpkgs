{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
<<<<<<< HEAD
  version = "0.4.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-yQD8IfMmqS3bgSTioEk9nU5yePlkqdVImhKvSZ3NNAw=";
  };

  cargoHash = "sha256-VxRvGD0D363vVD+XmUN1ylpfY4fLqkYDL6HwM81HG0Q=";
=======
  version = "0.4.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-L4axWXq79PC2l1j4IJbjrxYc9rzOHVHBV6503RKCBRU=";
  };

  cargoHash = "sha256-nAuMb9j+P6lR27RcKt1bOHP+4iRtLTV1ZlhHUxJk2Dw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = with lib.licenses; [ asl20 ];
    teams = [ lib.teams.cachix ];
    mainProgram = "secretspec";
  };
})
