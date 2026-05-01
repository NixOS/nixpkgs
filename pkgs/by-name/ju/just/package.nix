{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  bashInteractive,
  coreutils,
  installShellFiles,
  libiconv,
  mdbook,
  nix-update-script,
  # run the compiled `just` to build the completions
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  # run the compiled `just` to build the man pages
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  # run the compiled `generate-book` utility to prepare the files for mdbook
  withDocumentation ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:
let
  version = "1.43.1";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "just";
  outputs = [
    "out"
  ]
  ++ lib.optionals installManPages [
    "man"
  ]
  ++ lib.optionals withDocumentation [ "doc" ];

  src = fetchFromGitHub {
    owner = "casey";
    repo = "just";
    tag = version;
    hash = "sha256-ma1P8mcSnU/G/B/pN2tDEVokP+fGShGFodS2TG4wyQY=";
  };

  cargoHash = "sha256-nT5GTAvj2+ytbOpRNNVardchK1aXPCiJGSUp5ZoBCVA=";

  nativeBuildInputs =
    lib.optionals (installShellCompletions || installManPages) [ installShellFiles ]
    ++ lib.optionals withDocumentation [ mdbook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  preCheck = ''
    # USER must not be empty
    export USER=just-user
    export USERNAME=just-user
    export JUST_CHOOSER="${coreutils}/bin/cat"

    # Prevent string.rs from being changed
    cp tests/string.rs $TMPDIR/string.rs

    sed -i src/justfile.rs \
        -i tests/*.rs \
        -e "s@/bin/echo@${coreutils}/bin/echo@g" \
        -e "s@/usr/bin/env@${coreutils}/bin/env@g"

    # Return unchanged string.rs
    cp $TMPDIR/string.rs tests/string.rs

    # For shell completion tests
    export PATH=${bashInteractive}/bin:$PATH
    patchShebangs tests
  '';

  patches = [
    ./fix-just-path-in-tests.patch
  ];

  cargoBuildFlags = [
    "--package=just"
  ]
  ++ (lib.optionals withDocumentation [ "--package=generate-book" ]);

  checkFlags = [
    "--skip=backticks::trailing_newlines_are_stripped" # Wants to use python3 as alternate shell
    "--skip=choose::invoke_error_function" # wants JUST_CHOOSER to be fzf
    "--skip=choose::default" # symlinks cat->fzf which fails as coreutils doesn't understand name
    "--skip=config::tests::show_arguments" # interferes with JUST_CHOOSER being set
    "--skip=edit::editor_precedence" # trying to run "vim" fails as there's no /usr/bin/env or which in the sandbox to find vim and the dependency is not easily patched
    "--skip=shebang::run_shebang" # test case very rarely fails with "Text file busy"
  ];

  postInstall =
    lib.optionalString withDocumentation ''
      $out/bin/generate-book
      rm $out/bin/generate-book
      # No linkcheck in sandbox
      echo 'optional = true' >> book/en/book.toml
      mdbook build book/en
      mkdir -p $doc/share/doc/$name
      mv ./book/en/build/html $doc/share/doc/$name
    ''
    + lib.optionalString installManPages ''
      $out/bin/just --man > ./just.1
      installManPage ./just.1
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd just \
        --bash <($out/bin/just --completions bash) \
        --fish <($out/bin/just --completions fish) \
        --zsh <($out/bin/just --completions zsh)
    '';

  setupHook = ./setup-hook.sh;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/casey/just";
    changelog = "https://github.com/casey/just/blob/${version}/CHANGELOG.md";
    description = "Handy way to save and run project-specific commands";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      xrelkd
      jk
      ryan4yin
    ];
    mainProgram = "just";
  };
}
