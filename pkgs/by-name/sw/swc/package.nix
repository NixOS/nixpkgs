{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "swc";
  version = "0.91.369";

  env = {
    # swc depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };

  src = fetchCrate {
    pname = "swc_cli";
    inherit version;
    hash = "sha256-6n6zHMV87h1kmjzEmdE86/toHI99q2HO1EEGHUE9sg8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YuqoT5vGuUZfTenSgPPrC/7bTC0syiiiMYF/y0szG4Q=";

  meta = with lib; {
    description = "Rust-based platform for the Web";
    mainProgram = "swc";
    homepage = "https://github.com/swc-project/swc";
    license = licenses.asl20;
    maintainers = with maintainers; [
      dit7ya
      kashw2
    ];
  };
}
