{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  cmake,
  pkg-config,
  openssl,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "kellnr6";
  version = "6.0.3";

  src = fetchCrate {
    inherit version;
    pname = "kellnr";
    hash = "sha256-Eo3KhmX6BCL+Cc0eKMMJKAuDv/LTWnczIQGl+eJInAE=";
  };

  cargoHash = "sha256-PNWJjM++88FDH1HV/XVh1ruQnRsMNJr+IJiiUn6PYM0=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.isLinux [
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl.dev
  ]
  ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  OPENSSL_DIR = "${openssl.dev}";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";
  OPENSSL_LIB_DIR = "${openssl.out}/lib";
  OPENSSL_NO_VENDOR = "1";

  meta = {
    description = "Host your private Rust crates on your own infrastructure. Full control. Complete privacy. Zero dependencies on external services.";
    mainProgram = "kellnr";
    homepage = "kellnr.io";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ ];
  };
}
