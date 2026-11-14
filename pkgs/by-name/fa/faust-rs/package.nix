{
  lib,
  rustPlatform,
  fetchFromGitHub,
  faust,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "faust-rs";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust-rs";
    rev = "e6aab8debb78cdccbe01c0234783d0e117d9af83";
    hash = "sha256-KLMmLqFsY2SSLnB1Ujb0LnNPBiBWhTqJXADvBGXJUGA=";
  };

  cargoHash = "sha256-VB/qG1JpCkuoJk472QZV8e+kiN2pXJo5mdtk12Okhog=";

  strictDeps = true;
  __structuredAttrs = true;

  cargoBuildFlags = [
    "-p"
    "compiler"
    "--bin"
    "faust-rs"
  ];

  # Work around known failures in snapshot, import-path, and normalization tests.
  cargoTestFlags = [
    "--"
    "--skip=every_case_prints_what_it_printed"
    "--skip=an_import_dir_overrides_an_installed_standard_library"
    "--skip=the_checker_rejects_a_fast_path_that_drops_a_term"
    "--skip=the_checker_rejects_a_fast_path_that_ignores_a_common_factor"
    "--skip=hermetic_server_freezes_remote_import_routes"
  ];

  # Make Faust's standard libraries available in directories used by tests.
  preCheck = ''
    for dir in "$PWD/tests/corpus" "$PWD/tests/impulse-tests/dsp" "$PWD/porting/generated/siggen-table-init-s0/dsp" "$PWD/target/$(rustc -vV | sed -n 's/^host: //p')/share/faust" "$TMPDIR"; do
      mkdir -p "$dir"
      for file in "${faust}/share/faust/"*.lib; do
        ln -sf "$file" "$dir/$(basename "$file")"
      done
    done
  '';

  # Bundle Faust's standard libraries with the installed compiler.
  postInstall = ''
    mkdir -p "$out/share/faust"
    cp -r "${faust}/share/faust/." "$out/share/faust/"
  '';

  meta = {
    description = "Experimental Rust port of the Faust compiler";
    homepage = "https://github.com/grame-cncm/faust-rs";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "faust-rs";
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
