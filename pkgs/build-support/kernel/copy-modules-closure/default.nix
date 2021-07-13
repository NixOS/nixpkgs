{ lib, rustPlatform, nukeReferences, kmod }:

rustPlatform.buildRustPackage rec {
  pname = "copy-modules-closure";
  version = "0.1.0";
  src = ./.;
  cargoVendorDir = "vendor";
  meta = with lib; {
    description = "Copy closure of modules from kernel modules tree";
    license = licenses.mit;
    maintainers = with maintainers; [ xaverdh ];
  };
}
