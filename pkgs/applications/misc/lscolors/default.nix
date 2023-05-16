{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
<<<<<<< HEAD
  version = "0.15.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-C7aM9jlChRwPvYnBjLbV+sfbTHDVVi6evIR5PvT9jN4=";
  };

  cargoHash = "sha256-93FAEhl0WFXRq1SaoLRNDd/fy7NyDbeRFgIqUWAssQE=";

  buildFeatures = [ "nu-ansi-term" ];
=======
  version = "0.14.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-YVKs/1R//oKYBSSGnj6UMFo5zDp5O3QDDdkDKF4ICBk=";
  };

  cargoHash = "sha256-EJdjSFgvvwH5beW+aD1KT5G9bpW/8mdi+7c27KSkZjo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
<<<<<<< HEAD
    changelog = "https://github.com/sharkdp/lscolors/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
