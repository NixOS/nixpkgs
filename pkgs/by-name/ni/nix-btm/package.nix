{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-btm";
  version = "0.2.0";

  src = fetchCrate {
    inherit version;
    pname = "nix-btm";
    hash = "sha256-f8XFWlx+gwhF/OD8+tPcLGV/v0QnsDWOcqpY3Js+FAo=";
  };

  cargoHash = "sha256-zMQw3Q9t6JSMDt7xHMGTgAu9LW6MhG+Rrjpp5IEs/qQ=";

  meta = with lib; {
    description = "Rust tool to monitor Nix processes";
    homepage = "https://github.com/DieracDelta/nix-btm";
    license = licenses.mit;
    maintainers = with maintainers; [ DieracDelta ];
  };
}
