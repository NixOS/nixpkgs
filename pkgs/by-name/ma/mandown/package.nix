{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "mandown";
  version = "0.1.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TgOxRd8s2Vb4pNVPmFt2E5VnRHIEt6YlnTNyr91l6P8=";
  };

  cargoHash = "sha256-eHKivxnbOk3K2JEVIVHhaEds6Gr2TcYUnFuallHRV/0=";

  meta = with lib; {
    description = "Markdown to groff (man page) converter";
    homepage = "https://gitlab.com/kornelski/mandown";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    mainProgram = "mandown";
  };
}
