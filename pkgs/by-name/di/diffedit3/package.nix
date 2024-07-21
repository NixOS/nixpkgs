{ lib, rustPlatform, fetchCrate
, testers, nix-update-script, diffedit3
}:

rustPlatform.buildRustPackage rec {
  pname = "diffedit3";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qw5Wos2u/H6ccJ3qkrVOCisMFDTNwxp/YeOTE1x5lcU=";
  };

  cargoHash = "sha256-e5bm8GLubA9BzH9oKKSC/Ysh+O+GJA8x6W576vKIIUA=";

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion {
      package = diffedit3;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/ilyagr/diffedit3";
    description = "3-pane diff editor";
    license = with licenses; [ asl20 ];
    mainProgram = "diffedit3";
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
