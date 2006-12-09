{stdenv, configFiles}:

stdenv.mkDerivation {
  name = "etc";

  builder = ./make-etc.sh;

  /* !!! Use toXML. */
  sources = map (x: x.source) configFiles;
  targets = map (x: x.target) configFiles;
}
