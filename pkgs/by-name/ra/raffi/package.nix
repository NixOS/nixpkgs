{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  pkg-config,
  fuzzel,
  wayland,
  libxkbcommon,
  writableTmpDirAsHomeHook,
  additionalPrograms ? [ ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raffi";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QqUDIf7mUdhyhEZRVdm7L0ktqi49KATHv/2fwotoelc=";
  };

  cargoHash = "sha256-skCVhLmPY33vwZB+cYOJQfhq7JcF7o4X1qRq4G5HqOg=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    wayland
    libxkbcommon
  ];

  preCheck = ''
    # Several tests use `firefox` in their config fixtures. The test parses configs
    # via `read_config_from_reader` which validates that referenced binaries exist
    # in PATH, filtering out entries with missing binaries. Provide a stub so these
    # tests can run in the sandbox.
    mkdir -p "$TMPDIR/fake-bin"
    touch "$TMPDIR/fake-bin/firefox"
    chmod +x "$TMPDIR/fake-bin/firefox"
    export PATH="$TMPDIR/fake-bin:$PATH"
  '';

  checkFlags = [
    # These upstream tests replace PATH with /usr/bin:/bin, where `env` is
    # unavailable in the Nix sandbox; keep the rest of the release test suite.
    "--skip=tests::test_print_only_binary_shadowing_builtin_runs_external_program"
    "--skip=tests::test_print_only_binary_shadowing_shell_specific_builtin_runs_external_program"
    "--skip=tests::test_print_only_binary_shadowed_by_shell_function_runs_external_program"
    "--skip=tests::test_print_only_script_interpreter_shadowing_builtin_runs_external_program"
  ];

  postFixup = ''
    wrapProgram $out/bin/raffi \
      --prefix PATH : ${lib.makeBinPath ([ fuzzel ] ++ additionalPrograms)} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
        ]
      }
  '';

  meta = {
    description = "Fuzzel launcher based on yaml configuration";
    homepage = "https://github.com/chmouel/raffi";
    changelog = "https://github.com/chmouel/raffi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aos
      chmouel
      vdemeester
    ];
    mainProgram = "raffi";
    platforms = lib.platforms.linux;
  };
})
