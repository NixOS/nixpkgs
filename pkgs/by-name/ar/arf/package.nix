{
  lib,
  rustPlatform,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  air-formatter,
  rWrapper,
  rPackages,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arf";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "eitsupi";
    repo = "arf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cmIx03Ll5HryrrHAmQ2B5WenAmIWqehCM3MzjoGSvyk=";
  };

  cargoHash = "sha256-q5Xe95JfkqzNv1CzBFDg/WKqu4g4vnrKLE52qPDU2Bo=";

  nativeBuildInputs = [
    # Tests access home
    writableTmpDirAsHomeHook
  ];

  nativeCheckInputs = [
    air-formatter
    (rWrapper.override {
      packages = with rPackages; [
        askpass
        dplyr
      ];
    })
  ];

  checkFlags = [
    # Writes a script with #!/bin/sh as the hashbang and tries to execute it
    "--skip=external::formatter::tests::formatter_process_failure_is_returned_as_an_error"
    "--skip=input::bracketed_paste_handles_basic_long_multiline_and_multibyte_text"
    "--skip=input::unicode_output_preserves_wide_and_combining_characters"
    "--skip=output::askpass_does_not_echo_the_password_in_terminal_output"
    "--skip=reprex::rlang_error_detection_records_failure_status"
    "--skip=history::history_menu_selection_replaces_existing_buffer"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform R console written in Rust";
    homepage = "https://github.com/eitsupi/arf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chvp ];
    mainProgram = "arf";
    platforms = lib.platforms.unix;
  };
})
