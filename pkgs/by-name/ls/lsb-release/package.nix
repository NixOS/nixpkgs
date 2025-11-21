{
  replaceVarsWith,
  lib,
  runtimeShell,
  coreutils,
  getopt,
}:

replaceVarsWith {
  name = "lsb_release";

  src = ./lsb_release.sh;

  dir = "bin";
  isExecutable = true;

  replacements = {
    inherit coreutils getopt runtimeShell;
  };

  meta = {
    description = "Prints certain LSB (Linux Standard Base) and Distribution information";
    mainProgram = "lsb_release";
    license = [ lib.licenses.mit ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
