{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = pname;
    rev = version;
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
  ];

  meta = with lib; {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ masaeedu SuperSandro2000 zowoq ];
    mainProgram = "interactive-rebase-tool";
  };
}
