{ substituteAll, unzip, zip }:

substituteAll {
  name = "canonicalize-jar";
  src = ./canonicalize-jar.sh;

  unzip = "${unzip}/bin/unzip";
  zip = "${zip}/bin/zip";
}
