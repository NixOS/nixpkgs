{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  cacert,
  openssl,
  rustfmt,
  nix-update-script,
  testers,
  dioxus-cli,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dioxus-cli";
  version = "0.7.0-alpha.1";

  src = fetchCrate {
    pname = "dioxus-cli";
    version = finalAttrs.version;
    hash = "sha256-3b82XlxffgbtYbEYultQMzJRRwY/I36E1wgzrKoS8BU=";
  };

  postPatch = ''
    # wasm-opt-sys build.rs tries to verify C++17 support, but the check appears to be faulty.
    substituteInPlace $cargoDepsCopy/wasm-opt-sys-*/build.rs \
      --replace-fail 'check_cxx17_support()?;' '// check_cxx17_support()?;'
  '';

  cargoHash = "sha256-r42Z6paBVC2YTlUr4590dSA5RJJEjt5gfKWUl91N/ac=";
  buildFeatures = [
    "no-downloads"
    "optimizations"
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
    cacert
  ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    rustfmt
  ];

  checkFlags = [
    # requires network access
    "--skip=serve::proxy::test"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = dioxus-cli;
    };
  };

  meta = with lib; {
    description = "CLI for building fullstack web, desktop, and mobile apps with a single codebase.";
    homepage = "https://dioxus.dev";
    changelog = "https://github.com/DioxusLabs/dioxus/releases";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      xanderio
      cathalmullan
    ];
    sourceProvenance = with sourceTypes; [
      fromSource
    ];
    platforms = platforms.all;
    mainProgram = "dx";
  };
})
