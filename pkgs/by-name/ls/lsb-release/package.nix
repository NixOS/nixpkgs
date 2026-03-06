{
  replaceVarsWith,
  lib,
  runtimeShell,
  coreutils,
  getopt,
}:

replaceVarsWith {
  name = "lsb_release"; # Needed for lsb_release script name
  pname = "lsb_release";
  version = lib.trivial.release;

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
