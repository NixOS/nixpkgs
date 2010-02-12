{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rcs-5.7";
  
  src = fetchurl {
    url = ftp://ftp.cs.purdue.edu/pub/RCS/rcs-5.7.tar;
    md5 = "f7b3f106bf87ff6344df38490f6a02c5";
  };

  patches = [ ./no-root.patch ];

  meta = {
    homepage = http://www.cs.purdue.edu/homes/trinkle/RCS/;
    description = "Revision Control System, a version management system";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = [ stdenv.lib.platforms.all ];
  };
}
