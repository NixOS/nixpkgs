{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fontconfig,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "h5v";
  version = "0.15.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DanielHauge";
    repo = "h5v";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xDhZG07y/InXazGmQ/FpbQJZxozOWM0DeHg4VvVM+hc=";
  };

  cargoHash = "sha256-bmQhF5pfwkIvKxmXNmIqEMP9F0DMpvtf95aIe6U3BK8=";

  postPatch = ''
    substituteInPlace Cargo.toml macros/Cargo.toml \
      --replace-fail 'version = "0.1.0"' 'version = "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fontconfig
  ];

  checkFlags = [
    # sandbox-incompatible tests
    "--skip=importing::tests::resolves_csv_input_into_generated_hdf5_columns"
    "--skip=importing::tests::resolves_parquet_input_into_generated_hdf5_columns"
    "--skip=importing::tests::resolves_xlsx_input_into_sheet_groups"
    # fails in macOS CI sandbox due to lack of system fonts for chart rendering
    "--skip=ui::preview::chart::tests::preview_log_x_ignores_raw_index_zero"

    # test expects hardcoded "0.1.0" version which we correctly patched
    "--skip=configure::loading::tests::lua_ls_config_references_support_library"

    # force single-threaded tests to prevent HDF5 C-library segfaults
    "--test-threads=1"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "h5v";
    description = "HDF5 Terminal Viewer";
    longDescription = ''
      A terminal-first HDF5 explorer for charts, matrices,
      images, compound schemas, and scripted workflows.
    '';
    homepage = "https://github.com/DanielHauge/h5v";
    downloadPage = "https://github.com/DanielHauge/h5v/releases/tag/${finalAttrs.src.tag}";
    changelog = "https://github.com/DanielHauge/h5v/commits/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers = {
      cpeParts = lib.meta.cpeFullVersionWithVendor "DanielHauge" finalAttrs.version;
      purlParts = {
        type = "github";
        namespace = "DanielHauge";
        name = "h5v";
        version = finalAttrs.version;
      };
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
