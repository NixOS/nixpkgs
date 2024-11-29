{
  lib,
  fetchcvs,
  version,
}:

fetchcvs {
  cvsRoot = "anoncvs@anoncvs.fr.openbsd.org/cvs";
  module = "src";
  tag = "OPENBSD_${lib.replaceStrings [ "." ] [ "_" ] version}-RELEASE";
  sha256 = "sha256-hzdATew6h/FQV72SWtg3YvUXdPoGjm2SoUS7m3c3fSU=";
}
