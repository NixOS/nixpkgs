{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  neovim,
  util-linux,
  less,
  writableTmpDirAsHomeHook,
  xdotool,
  xprop,
  xmodmap,
  fzf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "keybind-find";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Benjmhart";
    repo = "keybind-find";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wPvySU1wvvcVbVQlRNOMTs8gOAIt3PdlWtMDPjv4Q/c=";
  };

  cargoHash = "sha256-lQaz3YiQBr8S5viHhHgRX4+rHuzSI6/dTexr/R8JYRo=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # Some tests run real programs: nvim, less, and setsid for the process-tree tests.
  nativeCheckInputs = [
    neovim
    util-linux
    less
    writableTmpDirAsHomeHook
  ];

  # tests/cli.rs runs stand-in pickers from /usr/bin or /bin, which the sandbox lacks: unit tests only.
  cargoTestFlags = [ "--bins" ];

  # These tests run stand-in programs that call /bin/cat, sleep and other tools by FHS paths or
  # from the user's PATH, start interactive shells, or time real processes; none of that works in the sandbox.
  checkFlags = map (t: "--skip=${t}") [
    "context::tests::less_is_found_anywhere_in_the_foreground_group"
    "context::tests::the_terminals_foreground_job_is_the_group_read"
    "providers::emacs::tests::a_server_that_hangs_is_an_error"
    "providers::emacs::tests::batch_answer_with_evil_and_an_init_error"
    "providers::emacs::tests::batch_runs_emacs_safely"
    "providers::emacs::tests::the_answer_of_the_right_emacs"
    "providers::emacs::tests::the_live_read_falls_back_to_batch"
    "providers::gnome::tests::custom_shortcuts_and_the_overlay_key"
    "providers::gnome::tests::each_schema_has_its_category"
    "providers::gnome::tests::failures"
    "providers::gnome::tests::mixed_values"
    "providers::gnome::tests::upstream_wm_defaults"
    "providers::gnome_terminal::tests::failures_are_one_error"
    "providers::less::tests::missing_or_hanging_less_is_an_error"
    "providers::less::tests::user_keys_need_less_582"
    "providers::mpv::tests::flatpak_config_dir_reaches_mpv"
    "providers::mpv::tests::temp_script_removed_after_success_failure_and_timeout"
    "providers::shells::tests::a_background_job_holding_stdout_keeps_the_keymap_and_is_killed"
    "providers::shells::tests::every_shell_through_read"
    "providers::shells::tests::real_bash_reads_inputrc_and_bashrc"
    "providers::vim::tests::the_live_read_falls_back"
    "providers::xfce::tests::failures_are_one_error"
  ];

  # The X11 tools and fzf are appended to PATH, so the user's own versions still win.
  # The picker window (alacritty, dmenu, fuzzel), the Wayland tools (swaymsg, wtype),
  # notify-send and the programs whose bindings it reads (nvim, tmux, espanso) are left to the user.
  postInstall = ''
    installManPage man/keybind-find.1
    wrapProgram $out/bin/keybind-find --suffix PATH : ${
      lib.makeBinPath [
        xdotool
        xprop
        xmodmap
        fzf
      ]
    }
  '';

  meta = {
    description = "Search the keybindings for the focused window and run the one you pick";
    homepage = "https://github.com/Benjmhart/keybind-find";
    changelog = "https://github.com/Benjmhart/keybind-find/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Benjmhart ];
    mainProgram = "keybind-find";
    platforms = lib.platforms.linux;
  };
})
