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

  cargoHash = "sha256-/Ku0W+L2mqVYDSkd2zRqM7UhHueXya4zjewp/xO/XlQ";

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
