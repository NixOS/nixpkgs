{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  libcosmicAppHook,
  just,

  # buildInputs
  openssl,

  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "forecast";
  version = "0-unstable-2025-05-15";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "forecast";
    rev = "7e10d602788c2da526c85cafdc5b167a8bfc2e2c";
    hash = "sha256-HsnQll+xqLXA3vRjsiYKkXLKw+uZZoJsSOfms4+fQg0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cLObhwMVnaj1HvMhCgSQOYN7IRPKcSeYuAfIy2V5Fns=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  buildInputs = [ openssl ];

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-forecast"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    description = "Weather app written in rust and libcosmic";
    homepage = "https://github.com/cosmic-utils/forecast";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-forecast";
  };
}
