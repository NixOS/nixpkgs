{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VIsop0XjadZQecKRbt+2U2qrMVmPaLZGUuMEY8v+aJ8=";
  };

  cargoHash = "sha256-wBTbHHCNZvp1xc6iiK6LzBFYsF9RPHA74YM6SDv6x94=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
