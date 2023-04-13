{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.2.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-w0YLSwRv6uhDwi06q0/mhGc5C6O2xq3vc9Se7/xXkhA=";
  };

  cargoHash = "sha256-Q0+6YgcdWa4RjNA7ffQJN0uIN8UFuCdbYjTFoM8w8uo=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
