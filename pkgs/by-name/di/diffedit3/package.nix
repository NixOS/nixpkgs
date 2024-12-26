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
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zBdLz8O2WCR8SN0UXUAaEdIpmmL+LIaGt44STBw6nyU=";
  };

  cargoHash = "sha256-jZTXM+2Gd4N9D4Pj2KsuQ2MFPuWJdHg30u/5BlM3HEE=";

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
