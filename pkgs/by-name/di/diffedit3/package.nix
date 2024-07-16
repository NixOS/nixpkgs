{ lib, rustPlatform, fetchCrate
, nix-update-script, versionCheckHook
}:

rustPlatform.buildRustPackage rec {
  pname = "diffedit3";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qw5Wos2u/H6ccJ3qkrVOCisMFDTNwxp/YeOTE1x5lcU=";
  };

  cargoHash = "sha256-e5bm8GLubA9BzH9oKKSC/Ysh+O+GJA8x6W576vKIIUA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/ilyagr/diffedit3";
    description = "3-pane diff editor";
    license = with licenses; [ asl20 ];
    mainProgram = "diffedit3";
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
