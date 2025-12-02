{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  clang,
  glibc,
  openssl,
  pkg-config,
  sqlite,
  fips ? false,
}:

rustPlatform.buildRustPackage (finalPackage: {
  pname = "kryoptic";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "kryoptic";
    tag = "v${finalPackage.version}";
    hash = "sha256-EzWZQLAtO7ZR28aOSfwXQOyHbL8Ss75dCxVnPkJIEbw=";
  };

  postPatch =
    let
      # Creates an -I command line for overriding an include.
      inc = name: ''format!("-I{}", env!("${name}_INCLUDE")).as_str()'';
      fipsArgs = lib.optionalString fips ''"-D_KRYOPTIC_FIPS"'';
    in
    ''
      substituteInPlace ossl/build.rs \
        --replace-fail 'ossl_bindings(&["-std=c90"], out_file)' 'ossl_bindings(&["-std=c90", ${inc "OPENSSL"}, ${inc "LIBC"}, ${fipsArgs}], out_file)'
    '';

  env = {
    # Pass these include paths for bindgen in via the environment.
    OPENSSL_INCLUDE = "${lib.getInclude openssl}/include";
    LIBC_INCLUDE = "${lib.getInclude glibc}/include";
    LIBCLANG_PATH = "${lib.getLib clang.cc}/lib";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    sqlite
  ];

  cargoPatches = [ ./cargo-lock.patch ];

  cargoHash = "sha256-NWtL1ZzxGqTn8SS4XitOYJvGRYA/j52f14oul4ZPoyw=";

  cargoBuildFlags = [
    "--no-default-features"
    "--features=${
      lib.concatStringsSep "," (
        [
          (if fips then "fips" else "standard")
          "dynamic" # dynamic linking
          "sqlitedb"
          "nssdb"
          "log"
        ]
        ++ lib.optionals (!fips) [
          "pqc" # post-quantum
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
