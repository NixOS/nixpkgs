{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    tag = "v${version}";
    hash = "sha256-LnJlE4ostOl+pr+d7ZsAfKvG4C45qt4pedWpeiTchPU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-o+hTK/7hw2/gLwGm5TozfZZyi674h2p55E7yfprB9wU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # bindgenHook is only included on darwin as it is needed to build `coreaudio-sys`, a darwin-specific crate
      rustPlatform.bindgenHook
    ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
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
