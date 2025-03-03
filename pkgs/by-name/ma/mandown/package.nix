{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "mandown";
  version = "1.0.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-30AM/t1Qq4xydG12Nh+J1MBKNvxxD/LVTkmTchsZHLw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-T3cUHyKQIYTL9jMoLsq6jEiIeFZcSZuyCna7TNEjGyU=";

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
