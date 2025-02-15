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

  useFetchCargoVendor = true;
  cargoHash = "sha256-a2RfwS45B2PrId4kxIx1Ko+tjED4ZU+WziOxa79q2/E=";

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
