{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "keepass-diff";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-CqLH5Dosp26YfqgOVcZilfo5svAEv+pAbi1zebGMnb4=";
  };

  cargoHash = "sha256-+kgb9hbCH4Nt80nobTeDrC+LVp1r6EbzUs+t6zlIhtU=";

  meta = with lib; {
    description = "CLI-tool to diff Keepass (.kdbx) files";
    homepage = "https://keepass-diff.narigo.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ wamserma ];
    mainProgram = "keepass-diff";
  };
}
