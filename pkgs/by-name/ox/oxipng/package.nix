{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  version = "9.1.3";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-kzN4YNsFqv/KUxpHao++oqc90Us6VllyFYkpdVUigD0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4c9YcIQRZsbDJvl8P9Pkd3atTVM+RbQ/4BMb7rE84po=";

  doCheck = !stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
