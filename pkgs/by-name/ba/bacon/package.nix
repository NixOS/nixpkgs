{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  versionCheckHook,
  bacon,
  nix-update-script,

  withSound ? false,
}:

let
  soundDependencies =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # bindgenHook is only included on darwin as it is needed to build `coreaudio-sys`, a darwin-specific crate
      rustPlatform.bindgenHook
    ];
in

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    tag = "v${version}";
    hash = "sha256-TniEPcY3mK5LO9CBXi5kgnUQkOeDwF9n1K0kSn4ucKk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6vR8Bxv/A6do4+oGAI0kx1yUyht7YOi1pP/mnIiBPmc=";

  buildFeatures = lib.optionals withSound [
    "sound"
  ];

  nativeBuildInputs = lib.optionals withSound [
    pkg-config
  ];

  buildInputs = lib.optionals withSound soundDependencies;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    tests = {
      withSound = bacon.override { withSound = true; };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Background rust code checker";
    mainProgram = "bacon";
    homepage = "https://github.com/Canop/bacon";
    changelog = "https://github.com/Canop/bacon/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      FlorianFranzen
      matthiasbeyer
    ];
  };
}
