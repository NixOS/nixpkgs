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

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ao2agqYChyrcrRVOjzKvPHYwmYGabQUVZAUaVBpAFJM=";

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
