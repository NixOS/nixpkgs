{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  clang,
  glibc,
  openssl,
  pkg-config,
  sqlite,
  withPostQuantum ? true,
}:

rustPlatform.buildRustPackage (finalPackage: {
  pname = "kryoptic";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "kryoptic";
    tag = "v${finalPackage.version}";
    hash = "sha256-tP2BZkGCZqfLNLZ/mYAVkICWKTM1EbL7lbw+Mnx4VTk=";
  };

  patches = [
    # Support additional arguments for bindgen so it can find our glibc.
    # https://github.com/latchset/kryoptic/pull/386
    ./ossl-bindgen-args.patch
  ];

  env = {
    # Pass these include paths for bindgen in via the environment.
    OSSL_BINDGEN_CLANG_ARGS = "-I${lib.getInclude glibc}/include";
    LIBCLANG_PATH = "${lib.getLib clang.cc}/lib";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    sqlite
  ];

  cargoPatches = [
    # https://github.com/latchset/kryoptic/pull/387
    ./cargo-lock.patch
  ];

  cargoHash = "sha256-yo+E/YrkL3YWEukIWeIt5gYsXHNCskXN99X7joztUAc=";

  cargoBuildFlags = [
    "--no-default-features"
    "--features=${
      lib.concatStringsSep "," (
        [
          "standard"
          "sqlitedb"
          "nssdb"
          "log"
        ]
        ++ lib.optionals withPostQuantum [
          "pqc" # post-quantum
        ]
        ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
          "dynamic"
        ]
      )
    }"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A PKCS#11 soft token written in Rust.";
    homepage = "https://github.com/latchset/kryoptic";
    maintainers = with lib.maintainers; [
      numinit
    ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
})
