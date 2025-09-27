{
  lib,
  stdenv,
  fetchurl,
  groff,
  mandoc,
  ncurses,
  nix-update-script,
  util-linux,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "myman";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/myman/myman/myman-${finalAttrs.version}.tar.gz";
    hash = "sha256-MalLLIlJo10Y7tNej2hYAfv+txQYo8Aer79xDOlaKSs=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    groff
    mandoc
    util-linux
  ];
  buildInputs = [ ncurses ];

  configureFlags = [
    "--with-ncursesw"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-D_XOPEN_SOURCE=600"
    "-D_GNU_SOURCE"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text-mode videogame inspired by Namco's Pac-Man";
    homepage = "https://myman.sourceforge.io/";
    license = lib.licenses.mit;
    mainProgram = "myman";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
