{
  fetchurl,
  lib,
  stdenv,
  makeWrapper,
  perl,
  openssh,
  rsync,
}:

stdenv.mkDerivation rec {
  pname = "autobuild";
  version = "5.3";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0gv7g61ja9q9zg1m30k4snqwwy1kq7b4df6sb7d2qra7kbdq8af1";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perl
    openssh
    rsync
  ];

  doCheck = true;

  meta = {
    description = "Continuous integration tool";

    longDescription = ''
      Autobuild is a package that process output from building
      software, primarily focused on packages using Autoconf and
      Automake, and then generate a HTML summary file, containing
      links to each build log.

      Autobuild can also help you automate building your project on
      many systems concurrently.  Users with accounts on the
      SourceForge compile farms will be able to invoke a parallel
      build of their Autoconf/Automake based software, and produce a
      summary of the build status, after reading the manual.
    '';

    homepage = "https://josefsson.org/autobuild/";
    license = lib.licenses.gpl2Plus;
  };
}
