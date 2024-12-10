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

  cargoHash = "sha256-4PCLtBJliK3uteL8EVKLBVR2YZW1gwQOiSLQok+rqug=";

  doCheck = !stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
