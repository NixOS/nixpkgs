{ fetchurl, stdenv }:

let version = "0.9";
in
  stdenv.mkDerivation {
    name = "cd-discid-${version}";
    src = fetchurl {
      url = "mirror://debian/pool/main/c/cd-discid/cd-discid_${version}.orig.tar.gz";
      sha256 = "1fx2ky1pb07l1r0bldpw16wdsfzw7a0093ib9v66kmilwy2sq5s9";
    };

    patches = [ ./install.patch ];

    configurePhase = ''
      sed -i "s|^[[:blank:]]*prefix *=.*$|prefix = $out|g ;
	      s|^[[:blank:]]*INSTALL *=.*$|INSTALL = install -c|g"  \
	  "Makefile";
    '';

    meta = {
      homepage = http://lly.org/~rcw/cd-discid/;
      license = stdenv.lib.licenses.gpl2Plus;
      description = "cd-discid, a command-line utility to retrieve a disc's CDDB ID";

      longDescription = ''
        cd-discid is a backend utility to get CDDB discid information
        from a CD-ROM disc.  It was originally designed for cdgrab (now
        abcde), but can be used for any purpose requiring CDDB data.
      '';
    };
  }
