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
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-o3Y3SQLkMxYMepGyvK6m/8aA5ZDwCAYdYUhGplkckjU=";
  };

  cargoHash = "sha256-XAtp5pCKFQRqyF9Y0udrcudgF5i3vWxk//kZ/hRsFaA=";

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
