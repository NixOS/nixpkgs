{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cdrtools-3.00";

  configurePhase = "true";

  src = fetchurl {
    url = "mirror://sourceforge/cdrtools/${name}.tar.bz2";
    sha256 = "0ga2fdwn3898jas5mabb6cc2al9acqb2yyzph2w76m85414bd73z";
  };

  patches = [ ./cdrtools-2.01-install.patch ];

  meta = {
    homepage = http://sourceforge.net/projects/cdrtools/;
    description = "Highly portable CD/DVD/BluRay command line recording software";
    # Licensing issues: This package contains code licensed under CDDL, GPL2
    # and LGPL2. There is debate regarding the legality of this licensing.
    # Marked as unfree to avoid any possible legal issues.
    license = stdenv.lib.licenses.unfree;
  };
}
