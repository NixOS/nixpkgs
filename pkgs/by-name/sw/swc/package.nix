{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "swc";
  version = "0.91.495";

  src = fetchCrate {
    pname = "swc_cli";
    inherit version;
    hash = "sha256-th+VLeKdTqyAjyRer0GeGLprBX0XhYTd9F7kwBDrzLo=";
  };

  cargoHash = "sha256-mIFZ9F0XS16OGSQlzu7H2wQZN4YUEKJlK+KHmkrc12w=";

  # swc depends on nightly features
  env.RUSTC_BOOTSTRAP = 1;

  meta = {
    description = "Rust-based platform for the Web";
    mainProgram = "swc";
    homepage = "https://github.com/swc-project/swc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dit7ya
      kashw2
    ];
  };
}
