{
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
} ./gog-unpack.sh
