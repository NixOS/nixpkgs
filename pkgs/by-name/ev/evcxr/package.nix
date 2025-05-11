{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  cmake,
  libiconv,
  cargo,
  gcc,
  mold,
  rustc,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "evcxr";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8PjZFWUH76QrA8EI9Cx0sBCzocvSmnp84VD7Nv9QMc8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hE/O6lHC0o+nrN4vaQ155Nn2gZscpfsZ6o7IDi/IEjI=";

  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    cmake
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  checkFlags = [
    # outdated rust-analyzer (disabled, upstream)
    # https://github.com/evcxr/evcxr/blob/fcdac75f49dcab3229524e671d4417d36c12130b/evcxr/tests/integration_tests.rs#L741
    # https://github.com/evcxr/evcxr/issues/295
    "--skip=partially_inferred_variable_type"
    # fail, but can't reproduce in the REPL
    "--skip=code_completion"
    "--skip=save_and_restore_variables"
  ];

  # Some tests fail when types aren't explicitly specified, but which can't be
  # reproduced inside the REPL.
  # Likely related to https://github.com/evcxr/evcxr/issues/295
  postConfigure = ''
    substituteInPlace evcxr/tests/integration_tests.rs \
      --replace-fail "let var2 = String" "let var2: String = String"           `# code_completion` \
      --replace-fail "let a = vec" "let a: Vec<i32> = vec"                     `# function_panics_{with,without}_variable_preserving` \
      --replace-fail "let a = Some(" "let a: Option<String> = Some("           `# moved_value` \
      --replace-fail "let a = \"foo\"" "let a: String = \"foo\""               `# statement_and_expression` \
      --replace-fail "let owned = \"owned\"" "let owned:String = \"owned\""    `# question_mark_operator` \
      --replace-fail "let mut owned_mut =" "let mut owned_mut: String ="
  '';

  postInstall =
    let
      wrap = exe: ''
        wrapProgram $out/bin/${exe} \
          --prefix PATH : ${
            lib.makeBinPath [
              cargo
              gcc
              mold # fix fatal error: "unknown command line option: -run"
              rustc # requires rust edition 2024
            ]
          } \
          --set-default RUST_SRC_PATH "$RUST_SRC_PATH"
      '';
    in
    ''
      ${wrap "evcxr"}
      ${wrap "evcxr_jupyter"}
      rm $out/bin/testing_runtime
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Evaluation context for Rust";
    homepage = "https://github.com/google/evcxr";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      protoben
      ma27
    ];
    mainProgram = "evcxr";
  };
})
