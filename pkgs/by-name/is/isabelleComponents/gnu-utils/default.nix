{
  lib,
  writeTextFile,
  coreutils,
  gnutar,
}:

writeTextFile {
  name = "gnu-utils-settings";
  text = ''
    ISABELLE_PRINTENV="${lib.getExe' coreutils "printenv"}"
    ISABELLE_TAR="${lib.getExe gnutar}"
  '';
  destination = "/etc/settings";
}
