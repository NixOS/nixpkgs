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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kryoptic";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "kryoptic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HT4XkUmk+j2XDWfbBOMg7blhNF2kx7V7bsUL7ZUAJAk=";
  };

  env = {
    # Pass these include paths for bindgen in via the environment.
    ${if !stdenv.hostPlatform.isDarwin then "OSSL_BINDGEN_CLANG_ARGS" else null} =
      "-I${lib.getInclude glibc}/include";
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

  cargoHash = "sha256-Qw5An3A9GyjzIb4+Dn7X8ab/vXd281Z9N+RnQQy/b4k=";

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
