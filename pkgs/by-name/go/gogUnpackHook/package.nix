{
  lib,
  makeSetupHook,
  innoextract,
  file-rename,
}:

makeSetupHook {
  name = "gog-unpack-hook";
  propagatedBuildInputs = [
    innoextract
    file-rename
  ];
  meta.license = lib.licenses.mit;
} ./gog-unpack.sh
