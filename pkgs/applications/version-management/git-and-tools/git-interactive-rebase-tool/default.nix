{ lib, stdenv, fetchFromGitHub, fetchpatch, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = pname;
    rev = version;
    sha256 = "sha256-DYl/GUbeNtKmXoR3gq8mK8EfsZNVNlrdngAwfzG+epw=";
  };

  cargoPatches = [
    # update git2 crate to fix a compile error
    (fetchpatch {
      url = "https://github.com/MitMaro/git-interactive-rebase-tool/commit/f4d3026f23118d29a263bbca6c83f963e76c34c4.patch";
      sha256 = "sha256-6ErPRcPbPRXbEslNiNInbbUhbOWb9ZRll7ZDRgTpWS4=";
    })
  ];

  cargoSha256 = "sha256-2aHW9JIiqkO0X0B0D44tSZ8QkmKH/QZoYvKNEQWldo4=";

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
  };
}
