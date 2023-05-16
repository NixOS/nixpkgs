{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
<<<<<<< HEAD
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-HFZSIzP3G6f78gTOpzZFG5ZAo5Lo6VuxQe6xMvCVfss=";
  };

  cargoHash = "sha256-ZsqxlwgXqw9eUEjw1DLBMz05V/y/ZbcrCL6I8TcnnDs=";
=======
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VIsop0XjadZQecKRbt+2U2qrMVmPaLZGUuMEY8v+aJ8=";
  };

  cargoHash = "sha256-wBTbHHCNZvp1xc6iiK6LzBFYsF9RPHA74YM6SDv6x94=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
