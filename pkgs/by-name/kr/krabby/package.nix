{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "krabby";
  version = "0.2.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-BmTx2kpnibTVuutAIrpFTTOGpO6WzITb6SXwUKuMtYY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Al9Ym+8HdunACRNMn6a3nrzoWVw1nAdRJmHqP3ch4lw=";

  meta = with lib; {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ruby0b ];
    mainProgram = "krabby";
  };
}
