{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
  fetchpatch,
  ncurses ? null,

  # Enable `termcap` (`ncurses`) support.
  enableTermcap ? false,
}:

assert lib.assertMsg (
  enableTermcap -> ncurses != null
) "`ncurses` must be provided when `enableTermcap` is enabled";

stdenv.mkDerivation (finalAttrs: {
  pname = "editline";
  version = "1.17.1";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = finalAttrs.version;
    sha256 = "sha256-0FeDUVCUahbweH24nfaZwa7j7lSfZh1TnQK7KYqO+3g=";
  };

  patches = [
    (fetchpatch {
      name = "fix-for-home-end-in-tmux.patch";
      url = "https://github.com/troglobit/editline/commit/265c1fb6a0b99bedb157dc7c320f2c9629136518.patch";
      sha256 = "sha256-9fhQH0hT8BcykGzOUoT18HBtWjjoXnePSGDJQp8GH30=";
    })

    # Pending autoconf-2.72 upstream support:
    #   https://github.com/troglobit/editline/pull/64
    (fetchpatch {
      name = "autoconf-2.72.patch";
      url = "https://github.com/troglobit/editline/commit/f444a316f5178b8e20fe31e7b2d979e651da077e.patch";
      hash = "sha256-m3jExTkPvE+ZBwHzf/A+ugzzfbLmeWYn726l7Po7f10=";
    })

    # Recognize `Alt-Left` and `Alt-Right` for navigating by words in more
    # terminals/shells/platforms.
    #
    # See: https://github.com/troglobit/editline/pull/70
    (fetchpatch {
      name = "alt-left-alt-right-word-navigation.patch";
      url = "https://github.com/troglobit/editline/commit/fb4d7268de024ed31ad2417f533cc0cbc2cd9b29.diff";
      hash = "sha256-5zMsmpU5zFoffRUwFhI/vP57pEhGotcMPgn9AfI1SNg=";
    })
  ];

  configureFlags = [
    # Enable SIGSTOP (Ctrl-Z) behavior.
    (lib.enableFeature true "sigstop")
    # Enable ANSI arrow keys.
    (lib.enableFeature true "arrow-keys")
    # Use termcap library to query terminal size.
    (lib.enableFeature enableTermcap "termcap")
  ];

  nativeBuildInputs = [ autoreconfHook ];

  propagatedBuildInputs = lib.optional enableTermcap ncurses;

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://troglobit.com/projects/editline/";
    description = "Readline() replacement for UNIX without termcap (ncurses)";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ oxalica ];
    platforms = platforms.all;
  };
})
