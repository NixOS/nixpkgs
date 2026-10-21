{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "auto-fix-elf-files";
  meta.license = lib.licenses.mit;
} ./auto-fix-elf-files.sh
