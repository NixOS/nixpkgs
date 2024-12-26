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
}:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "1.38.0";
  outputs = [
    "out"
    "man"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-jIc8+SFAcH2TsY12+txwlMoJmpDdDpC0H+UrjYH61Lk=";
  };

  cargoHash = "sha256-JHLkjMy5b1spJrAqFCCzqgnlYTAKA1Z9Tx4w1WWuiAI=";

  nativeBuildInputs = [
    installShellFiles
    mdbook
  ];
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

  postBuild = ''
    cargo run --package generate-book

    mkdir -p completions man

    cargo run -- --man > man/just.1

    for shell in bash fish zsh; do
        cargo run -- --completions $shell > completions/just.$shell
    done

    # No linkcheck in sandbox
    echo 'optional = true' >> book/en/book.toml
    mdbook build book/en
    find .
  '';

  checkFlags = [
    "--skip=backticks::trailing_newlines_are_stripped" # Wants to use python3 as alternate shell
    "--skip=choose::invoke_error_function" # wants JUST_CHOOSER to be fzf
    "--skip=choose::default" # symlinks cat->fzf which fails as coreutils doesn't understand name
    "--skip=config::tests::show_arguments" # interferes with JUST_CHOOSER being set
    "--skip=edit::editor_precedence" # trying to run "vim" fails as there's no /usr/bin/env or which in the sandbox to find vim and the dependency is not easily patched
    "--skip=shebang::run_shebang" # test case very rarely fails with "Text file busy"
  ];

  postInstall = ''
    mkdir -p $doc/share/doc/$name
    mv ./book/en/build/html $doc/share/doc/$name
    installManPage man/just.1

    installShellCompletion --cmd just \
      --bash completions/just.bash \
      --fish completions/just.fish \
      --zsh completions/just.zsh
  '';

  setupHook = ./setup-hook.sh;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/casey/just";
    changelog = "https://github.com/casey/just/blob/${version}/CHANGELOG.md";
    description = "Handy way to save and run project-specific commands";
    license = licenses.cc0;
    maintainers = with maintainers; [
      xrelkd
      jk
    ];
    mainProgram = "just";
  };
}
