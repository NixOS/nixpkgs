{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clex";
  version = "4.7";

  src = fetchurl {
    url = "https://github.com/xitop/clex/releases/download/v${finalAttrs.version}/clex-${finalAttrs.version}.tar.gz";
    hash = "sha256-3Y3ayJEy9pHLTUSeXYeekTVdopwKLZ8vVcVarLIFnpM=";
  };

  buildInputs = [ ncurses ];

  enableParallelBuilding = true;

  meta = {
    description = "File manager with full-screen terminal interface";
    longDescription = ''
      CLEX (pronounced KLEKS) displays directory contents including the file
      status details and provides features like command history, filename
      insertion, or name completion in order to help users to create commands
      to be executed by the shell. There are no built-in commands, CLEX is an
      add-on to your favorite shell.
    '';
    homepage = "https://github.com/xitop/clex";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
  };
})
