{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  sqlite,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "intelli-shell";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${version}";
    hash = "sha256-mvvFW+YsUxL/TX/KJ5oSbXad6ZJOcxydqyN15fLlXeY=";
  };

  cargoHash = "sha256-ZjfqaSbFPX7USOtcnrlny9Mqnl9mI2pddn9/5bl+OdM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    sqlite
    zlib
  ];

  checkType = "debug";

  checkFlags = [
    "--skip=utils::completion::tests::test_resolve_completions_returns_all_results_including_duplicates"
    "--skip=utils::completion::tests::test_resolve_completions_with_mixed_success_and_failure"
    "--skip=utils::completion::tests::test_resolve_completions_with_multiple_errors"
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    # Install bash completion
    mkdir -p $out/share/bash-completion/completions
    cp src/_shell/intelli-shell.bash $out/share/bash-completion/completions/intelli-shell

    # Install zsh completion
    mkdir -p $out/share/zsh/site-functions
    cp src/_shell/intelli-shell.zsh $out/share/zsh/site-functions/_intelli-shell

    # Install fish completion
    mkdir -p $out/share/fish/vendor_completions.d
    cp src/_shell/intelli-shell.fish $out/share/fish/vendor_completions.d/intelli-shell.fish
  '';

  meta = with lib; {
    description = "Like IntelliSense, but for shells (IntelliShell)";
    homepage = "https://github.com/lasantosr/intelli-shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "intelli-shell";
  };
}
