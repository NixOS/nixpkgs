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
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = "bear";
    rev = finalAttrs.version;
    hash = "sha256-gbDRK4M13jRBCIYWn8so4bKHqCjL2YOF15CqIB2HqIQ=";
  };

  cargoHash = "sha256-BZaydfkYyYtQWvM16VwBbeIz/vyfYSa/jSIulnWBNg8=";

  nativeBuildInputs = [
    installShellFiles
    lld
    makeWrapper
  ];

  # buildRustPackage sets RUST_LOG="", which bear's env_logger parses
  # as error-only, hiding warnings the tests assert on.
  env.RUST_LOG = "info";

  checkFlags = [
    # exec*p PATH search falls back to libc's default path, empty in the sandbox
    "--skip"
    "cases::intercept_posix::execlp_interception"
    "--skip"
    "cases::intercept_posix::execvp_interception"
    "--skip"
    "cases::intercept_posix::execvpe_interception"
    "--skip"
    "cases::intercept_posix::posix_spawnp_interception"

    # sandbox /bin/sh is static busybox, LD_PRELOAD can't see its children
    "--skip"
    "cases::intercept_posix::popen_interception"
    "--skip"
    "cases::intercept_posix::system_interception"
    "--skip"
    "cases::hardened_intercept::hardened_popen_after_unsetenv"
    "--skip"
    "cases::hardened_intercept::hardened_system_after_unsetenv"

    # nixpkgs gcc is a wrapper script execing real gcc, doubling the event count
    "--skip"
    "cases::intercept::parallel_command_interception"
  ];

  postInstall = ''
    install -d $out/libexec/bear/bin $out/libexec/bear/lib
    mv $out/bin/bear-driver $out/libexec/bear/bin/
    mv $out/bin/bear-wrapper $out/libexec/bear/bin/
    mv $out/lib/libexec.so $out/libexec/bear/lib/

    makeWrapper $out/libexec/bear/bin/bear-driver $out/bin/bear

    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      $out/bin/generate-completions completions
      # Bear has broken zsh completions (https://github.com/clap-rs/clap/issues/6313)
      installShellCompletion --cmd bear \
        --bash completions/bear.bash \
        --fish completions/bear.fish
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
