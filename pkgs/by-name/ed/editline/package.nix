{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
  ncurses ? null,

  # Enable `termcap` (`ncurses`) support.
  enableTermcap ? false,
}:

assert lib.assertMsg (
  enableTermcap -> ncurses != null
) "`ncurses` must be provided when `enableTermcap` is enabled";

stdenv.mkDerivation (finalAttrs: {
  pname = "editline";
  version = "1.17.1-unstable-2025-05-24";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = "f735e4d1d566cac3caa4a5e248179d07f0babefd";
    sha256 = "sha256-MUXxSmhpQd8CZdGGC6Ln9eci85E+GBhlNk28VHUvjaU=";
  };

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
