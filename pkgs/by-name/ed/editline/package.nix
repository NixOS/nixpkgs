{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
  testers,
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
    rev = "f735e4d1d566cac3caa4a5e248179d07f0babefd";
    hash = "sha256-MUXxSmhpQd8CZdGGC6Ln9eci85E+GBhlNk28VHUvjaU=";
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

  strictDeps = true;

  makeFlags = lib.optionals stdenv.hostPlatform.isPE [
    "LDFLAGS=-no-undefined"
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      version = "1.17.2-pre";
    };
  };

  __structuredAttrs = true;

  meta = {
    homepage = "https://troglobit.com/projects/editline/";
    description = "Readline() replacement for UNIX without termcap (ncurses)";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ oxalica ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "libeditline" ];
  };
})
