{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  lld,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bear";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = "bear";
    rev = finalAttrs.version;
    hash = "sha256-W0t4UfTytoIXQ39LjHvA9U5owZJMsZNQd+fZ21DvsIg=";
  };

  cargoHash = "sha256-ckWcNHR8D1FUWCFiP1SHdCzsDWppBbuZ/YG0hRj3F+4=";

  nativeBuildInputs = [
    installShellFiles
    lld
    makeWrapper
  ];

  # buildRustPackage sets RUST_LOG="", which env_logger parses as
  # error-only, hiding warnings the tests assert on.
  env.RUST_LOG = "info";

  # Run tests serially to reduce contention around their fixed startup deadlines.
  dontUseCargoParallelTests = true;

  postInstall = ''
    install -d $out/libexec/bear/bin $out/libexec/bear/lib
    mv $out/bin/bear-driver $out/libexec/bear/bin/
    mv $out/bin/bear-wrapper $out/libexec/bear/bin/
    mv $out/lib/libexec${stdenv.hostPlatform.extensions.sharedLibrary} $out/libexec/bear/lib/

    makeWrapper $out/libexec/bear/bin/bear-driver $out/bin/bear

    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      $out/bin/generate-completions completions
      installShellCompletion --cmd bear \
        --bash completions/bear.bash \
        --fish completions/bear.fish \
        --zsh completions/_bear
    ''}

    rm $out/bin/generate-completions $out/bin/cdb-compare

    installManPage man/bear.1
  '';

  # Functional tests use loopback networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool that generates a compilation database for clang tooling";
    mainProgram = "bear";
    longDescription = ''
      Note: the bear command is very useful to generate compilation commands
      e.g. for YouCompleteMe.  You just enter your development nix-shell
      and run `bear make`.  It's not perfect, but it gets a long way.
    '';
    homepage = "https://github.com/rizsotto/Bear";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ DieracDelta ];
  };
})
