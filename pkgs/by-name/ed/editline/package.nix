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
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = finalAttrs.version;
    sha256 = "sha256-elREUDoHseXQzq0vXw6scz+FbyIgrt8BOrL1Qk5wOfE=";
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

  makeFlags = lib.optionals stdenv.hostPlatform.isPE [
    "LDFLAGS=-no-undefined"
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://troglobit.com/projects/editline/";
    description = "Readline() replacement for UNIX without termcap (ncurses)";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ oxalica ];
    platforms = lib.platforms.all;
  };
})
