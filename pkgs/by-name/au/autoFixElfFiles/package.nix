{ arrayUtilities, makeSetupHook }:

makeSetupHook {
  name = "auto-fix-elf-files";
  propagatedBuildInputs = [ arrayUtilities.getElfFiles ];
} ./auto-fix-elf-files.sh
