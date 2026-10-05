{
  lib,
  vim,
  writableTmpDirAsHomeHook,
}:

# Vim's own test suite (src/testdir), run against the vim derivation.
vim.overrideAttrs (old: {
  pname = "${old.pname}-test-suite";

  doCheck = true;

  env = old.env or { } // {
    # Test functions matching this Vim regex are skipped; see src/testdir/runtest.vim.
    TEST_SKIP_PAT = lib.concatMapStringsSep "\\|" (test: "^${test}(") [
      # :terminal runs /bin/sh, which is BusyBox ash in the sandbox; its banner
      # shows up in the screendumps.
      "Test_popup_drag_termwin"
      "Test_popup_opacity_global_terminal_close_no_leftover"
      "Test_popup_opacity_tablocal_terminal_close_no_leftover"
      "Test_popup_opacity_terminal_move_no_leftover"

      # 'backupskip' contains $TMPDIR/*, $TEMP/* and $TMP/*, which all cover
      # the build directory.
      "Test_write_backup_symlink"

      # GetLatestVimScripts downloads plugins from vim.org.
      "Test_glvs_default_tar_xz"
      "Test_glvs_default_vba_gz"
      "Test_glvs_default_vim_bz2"
      "Test_glvs_default_vmb"
    ];
  };

  nativeCheckInputs = old.nativeCheckInputs or [ ] ++ [ writableTmpDirAsHomeHook ];

  preCheck = ''
    export TERM=xterm

    # Vim exits when it reads EOF on stdin, which /dev/null in the sandbox gives
    # it immediately: every test that waits for typeahead (getchar(), mappings,
    # 'writedelay', ...) kills the rest of its file. A FIFO opened read-write
    # never reaches EOF.
    mkfifo "$TMPDIR/stdin"
  '';

  checkPhase = ''
    runHook preCheck
    make test <>"$TMPDIR/stdin"
    runHook postCheck
  '';
})
