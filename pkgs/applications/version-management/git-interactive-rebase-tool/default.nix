{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = pname;
    rev = version;
    sha256 = "sha256-tMeA2LsNCXxI086y8S+STYwjClWMPaBheP0s0oZ5I5c=";
  };

  postPatch = ''
    # error: lint `unused_tuple_struct_fields` has been renamed to `dead_code`
    substituteInPlace scripts/data/lints.rs src/main.rs src/{config,core,display,git,input,runtime,testutils,todo_file,view}/src/lib.rs \
      --replace-fail "unused_tuple_struct_fields," ""
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "claim-0.5.0" = "sha256-quVV5PnWW1cYK+iSOM/Y0gLu2gPOrZ1ytJif0D5v9g0=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  # Compilation during tests fails if this env var is not set.
  preCheck = "export GIRT_BUILD_GIT_HASH=${version}";
  postCheck = "unset GIRT_BUILD_GIT_HASH";
  cargoTestFlags = [
    "--workspace"
    # build everything except for doctests which are currently broken because
    # `config::lib` expects the sourcetree to be a git repo.
    "--tests"
    "--lib"
    "--bins"
  ];

  meta = with lib; {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      SuperSandro2000
      zowoq
      ma27
    ];
    mainProgram = "interactive-rebase-tool";
  };
}
