{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  icu,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microsoft-edit";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "edit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ubdZynQVwCYhZA/z4P/v6aX5rRG9BCcWKih/PzuPSeE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qT4u8LuKX/QbZojNDoK43cRnxXwMjvEwybeuZIK6DQQ=";
  # Requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  buildInputs = [
    icu
  ];

  # https://github.com/microsoft/edit/blob/f8bea2be191d00baa2a4551817541ea3f8c5b03e/src/icu.rs#L834
  # Required for Ctrl+F searching to work
  postFixup = ''
    patchelf $out/bin/edit \
      --add-rpath ${lib.makeLibraryPath [ icu ]}
  '';

  # Disabled for now, microsoft/edit#194
  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/edit";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple editor for simple needs";
    longDescription = ''
      This editor pays homage to the classic MS-DOS Editor,
      but with a modern interface and input controls similar to VS Code.
      The goal is to provide an accessible editor that even users largely
      unfamiliar with terminals can easily use.
    '';
    mainProgram = "edit";
    homepage = "https://github.com/microsoft/edit";
    changelog = "https://github.com/microsoft/edit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
})
