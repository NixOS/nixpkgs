{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  libsecret,
  openssl,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tasks";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "tasks";
    tag = version;
    hash = "sha256-OKXkAJ+TyMnTzvlUPwPU2MWgCTIN3cDiPcVPOzU4WEg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3SbqKB9DI1Bl8u8rrAPCO/sPKMByYhQ3YT63K5BDVvE=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    libsecret
    openssl
    sqlite
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/tasks"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/cosmic-utils/tasks/releases/tag/${version}";
    description = "Simple task management application for the COSMIC desktop";
    homepage = "https://github.com/cosmic-utils/tasks";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
    mainProgram = "tasks";
  };
}
