{
  lib,
  stdenv,
  fetchpatch,
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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kryoptic";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "kryoptic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tP2BZkGCZqfLNLZ/mYAVkICWKTM1EbL7lbw+Mnx4VTk=";
  };

  patches = [
    # Support additional arguments for bindgen so it can find our glibc.
    # https://github.com/latchset/kryoptic/pull/386
    (fetchpatch {
      url = "https://github.com/latchset/kryoptic/commit/54b3deeb4eb84ebd7c5b52ccb9401e319fb00294.patch";
      hash = "sha256-QChVS/MnsGp6To4OWYA8Se6kgRCGABchLLnSHfrEj1E=";
    })
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
    ./0001-Add-Cargo.lock.patch
  ];

  cargoHash = "sha256-eekiW9HCKwx7/y2WSqQH6adgAeAnQojM3QcNTc3kx2I=";

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
