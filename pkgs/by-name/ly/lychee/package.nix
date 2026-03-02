{
  callPackage,
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  openssl,
  testers,
}:

let
  canRun = stdenv.hostPlatform.emulatorAvailable buildPackages;
  lychee = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/lychee${stdenv.hostPlatform.extensions.executable}";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lychee";
  version = "0.22.0-unstable-2025-12-05";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = "lychee";
    # tag = "lychee-v${finalAttrs.version}"; # use again with next release
    rev = "db0f8a842f594e0a879563caf7d183266c02ca95"; # one revision after 0.22.0
    leaveDotGit = true;
    postFetch = ''
      GIT_DATE=$(git -C $out/.git show -s --format=%cs)
      substituteInPlace $out/lychee-bin/build.rs \
        --replace-fail \
          '("cargo:rustc-env=GIT_DATE={}", git_date())' \
          '("cargo:rustc-env=GIT_DATE={}", "'$GIT_DATE'")'
      rm -rf $out/.git
    '';
    hash = "sha256-l8/llYq8rwt+UQMLnsva4/2m53cwqaJXD/XvgEfxXg4=";
  };

  cargoHash = "sha256-03eahQ6GvOPxnvC82lfT1J/XfOg9V7gOZeOEBJx8IYY=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ openssl ];

  postFixup = lib.optionalString canRun ''
    ${lychee} --generate man > lychee.1
    installManPage lychee.1
  '';

  cargoTestFlags = [
    # don't run doctests since they tend to use the network
    "--lib"
    "--bins"
    "--tests"
  ];

  checkFlags = [
    #  Network errors for all of these tests
    # "error reading DNS system conf: No such file or directory (os error 2)" } }
    "--skip=archive::wayback::tests::wayback_suggestion_real_unknown"
    "--skip=archive::wayback::tests::wayback_api_no_breaking_changes"
    "--skip=cli::test_dont_dump_data_uris_by_default"
    "--skip=cli::test_dump_data_uris_in_verbose_mode"
    "--skip=cli::test_exclude_example_domains"
    "--skip=cli::test_local_dir"
    "--skip=cli::test_local_file"
    "--skip=client::tests"
    "--skip=collector::tests"
    "--skip=commands::generate::tests::test_examples_work"
    "--skip=src/lib.rs"
    # Color error for those tests as we are not in a tty
    "--skip=formatters::response::color::tests::test_format_response_with_error_status"
    "--skip=formatters::response::color::tests::test_format_response_with_ok_status"
  ];

  passthru.tests = {
    # NOTE: These assume that testers.lycheeLinkCheck uses this exact derivation.
    #       Which is true most of the time, but not necessarily after overriding.
    ok = callPackage ./tests/ok.nix { };
    fail = callPackage ./tests/fail.nix { };
    fail-emptyDirectory = callPackage ./tests/fail-emptyDirectory.nix { };
    network = testers.runNixOSTest ./tests/network.nix;
  };

  meta = {
    description = "Fast, async, stream-based link checker written in Rust";
    homepage = "https://github.com/lycheeverse/lychee";
    downloadPage = "https://github.com/lycheeverse/lychee/releases/tag/lychee-v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      totoroot
      tuxinaut
    ];
    mainProgram = "lychee";
  };
})
