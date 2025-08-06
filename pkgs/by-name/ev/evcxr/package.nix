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

  # On non-darwin, `mold` is the default linker, but it's broken on Darwin.
  withMold ? with stdenv.hostPlatform; isUnix && !isDarwin,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "evcxr";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8dV+NNtU4HFerrgRyc1kO+MSsMTJJItTtJylEIN014g=";
  };

  cargoHash = "sha256-HJrEXt6O7qCNJ/xOh4kjmqKJ22EVwBTzV1S+q98k0VQ=";

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
            lib.makeBinPath (
              [
                cargo
                gcc
                rustc
              ]
              ++ lib.optional withMold mold
            )
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
