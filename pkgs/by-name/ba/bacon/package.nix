{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  alsa-lib,
  versionCheckHook,
  bacon,
  buildPackages,
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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bacon";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/m549z9NWZhkn6/Y6WM1+og0vyg1DbqZmK3oGpydQa0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-X35mC8c1NeonUA1yYO9C7KCzHKpyIn6mbVWkZUhv+Es=";

  buildFeatures = lib.optionals withSound [
    "sound"
  ];

  nativeBuildInputs =
    [
      installShellFiles
    ]
    ++ lib.optionals withSound [
      pkg-config
    ];

  buildInputs = lib.optionals withSound soundDependencies;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  postInstall =
    let
      bacon = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/bacon";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd bacon \
        --bash <(COMPLETE=bash ${bacon}) \
        --fish <(COMPLETE=fish ${bacon}) \
        --zsh <(COMPLETE=zsh ${bacon})
    '';

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
    changelog = "https://github.com/Canop/bacon/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      FlorianFranzen
      matthiasbeyer
    ];
  };
})
