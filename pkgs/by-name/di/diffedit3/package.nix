{
  lib,
  rustPlatform,
  fetchCrate,
  testers,
  nix-update-script,
  diffedit3,
}:

rustPlatform.buildRustPackage rec {
  pname = "diffedit3";
  version = "0.6.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-tlrP97XMAAnk5H5wTHPsP1DMSmDqV9wJp1n+22jUtnM=";
  };

  cargoHash = "sha256-Hv3T0pxNUwp7No5tmFopMGjNdxfje4gRODj3B7sDVcg=";

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
