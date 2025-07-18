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
  version = "0.7.0-alpha.3";

  src = fetchCrate {
    pname = "dioxus-cli";
    version = finalAttrs.version;
    hash = "sha256-ibEniOqI0IW9ME+k/rCYUgOpYS16wpzPXFxgn0XAzQo=";
  };

  cargoHash = "sha256-t5umDmhU8IC5Rau5ssyW0bZnnBI7JxL8A5qlW4WEDOg=";
  buildFeatures = [
    "no-downloads"
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
