{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  rust-jemalloc-sys,
  testers,
  fd,
}:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "10.3.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    hash = "sha256-rUoR8LHtzwGQBwJGEsWpMYKG6HcGKcktcyF7TxTDJs8=";
  };

  cargoHash = "sha256-yiR23t48I0USD21tnFZzmTmO0D8kWNzP9Ff3QM9GitU=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ rust-jemalloc-sys ];

  # skip flaky test
  checkFlags = [
    "--skip=test_owner_current_group"
    # Fails if the filesystem performs UTF-8 validation (such as ZFS with utf8only=on)
    "--skip=test_exec_invalid_utf8"
    "--skip=test_invalid_utf8"
  ];

  postInstall = ''
    installManPage doc/fd.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fd \
      --bash <($out/bin/fd --gen-completions bash) \
      --fish <($out/bin/fd --gen-completions fish)
    installShellCompletion --zsh contrib/completion/_fd
  '';

  passthru.tests.version = testers.testVersion {
    package = fd;
  };

  meta = {
    description = "Simple, fast and user-friendly alternative to find";
    longDescription = ''
      `fd` is a simple, fast and user-friendly alternative to `find`.

      While it does not seek to mirror all of `find`'s powerful functionality,
      it provides sensible (opinionated) defaults for 80% of the use cases.
    '';
    homepage = "https://github.com/sharkdp/fd";
    changelog = "https://github.com/sharkdp/fd/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      dywedir
      figsoda
      globin
      ma27
      zowoq
      matthiasbeyer
    ];
    mainProgram = "fd";
  };
}
