{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shtk";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "jmmv";
    repo = "shtk";
    tag = "shtk-${finalAttrs.version}";
    hash = "sha256-EnJpysBI00JqLsRzdrHW62gV0wXx/Q+tpLR26jrgukU=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "SHTK_SHELL=${stdenv.shell}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = ''
    # The "shtk" binary is only used when building packages that need shtk at
    # runtime, so it's only a developer tool.
    moveToOutput bin "$dev"

    moveToOutput share/aclocal "$dev"
    moveToOutput lib/pkgconfig "$dev"

    substituteInPlace "$dev/lib/pkgconfig/shtk.pc" \
      --replace-fail "$out/bin/shtk" "$dev/bin/shtk"

    # Do not install tests.  This is a weird pattern that not many packages
    # follow.
    rm -rf "$out/tests"
  '';

  meta = {
    description = "Application toolkit for programmers writing POSIX-compliant shell scripts";
    longDescription = ''
      The Shell Toolkit, or shtk for short, is an application toolkit
      for programmers writing POSIX-compliant shell scripts.

      shtk provides a collection of reusable modules that work on a wide
      variety of operating systems and shell interpreters. These modules are all
      ready to be used by calling the provided shtk_import primitive and
      "compiling" the shell scripts into their final form using the shtk(1)
      utility.

      shtk is purely written in the shell scripting language so there are no
      dependencies to be installed, and is known to be compatible with at least
      bash, dash, pdksh and zsh.
    '';
    homepage = "https://github.com/jmmv/shtk";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jmmv ];
    platforms = lib.platforms.unix;
    mainProgram = "shtk";
  };
})
