{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-tMeA2LsNCXxI086y8S+STYwjClWMPaBheP0s0oZ5I5c=";
  };

  postPatch = ''
    # unknown lint: `ffi_unwind_calls`
    # note: the `ffi_unwind_calls` lint is unstable
    substituteInPlace src/main.rs src/{config,core,display,input,git,runtime,todo_file,testutils,view}/src/lib.rs \
      --replace "ffi_unwind_calls," ""
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "claim-0.5.0" = "sha256-quVV5PnWW1cYK+iSOM/Y0gLu2gPOrZ1ytJif0D5v9g0=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

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
=======
    sha256 = "sha256-KqItunxh24jAkvsAMnByS+dhm+wyUqmdF96qEDs/5mI=";
  };

  cargoSha256 = "sha256-510kNtcSsuXADMmSqu2t0HsnPUS/Jedsfvjnh2k+vDs=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlags = [
    "--skip=external_editor::tests::edit_success"
    "--skip=external_editor::tests::editor_non_zero_exit"
    "--skip=external_editor::tests::empty_edit_abort_rebase"
    "--skip=external_editor::tests::empty_edit_error"
    "--skip=external_editor::tests::empty_edit_noop"
    "--skip=external_editor::tests::empty_edit_re_edit_rebase_file"
    "--skip=external_editor::tests::empty_edit_undo_and_edit"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${version}";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ SuperSandro2000 zowoq ma27 ];
=======
    maintainers = with maintainers; [ masaeedu SuperSandro2000 zowoq ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "interactive-rebase-tool";
  };
}
