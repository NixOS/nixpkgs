{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.14.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-YVKs/1R//oKYBSSGnj6UMFo5zDp5O3QDDdkDKF4ICBk=";
  };

  cargoHash = "sha256-EJdjSFgvvwH5beW+aD1KT5G9bpW/8mdi+7c27KSkZjo=";

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
