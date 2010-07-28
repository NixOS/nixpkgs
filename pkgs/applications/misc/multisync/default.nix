{ stdenv, fetchurl, gtk, glib, ORBit2, libbonobo, libtool, pkgconfig
, libgnomeui, GConf, automake, autoconf }:

stdenv.mkDerivation {
  name = "multisync-0.82-1";
  
  src = fetchurl {
    url = mirror://sourceforge/multisync/multisync-0.82-1.tar.bz2;
    sha256 = "1azb6zsn3n1rnla2qc3c440gc4vgmbj593k6xj5g1v0xha2vm2y3";
  };
  
  buildInputs =
    [ gtk glib ORBit2 libbonobo libtool pkgconfig libgnomeui GConf
      automake autoconf
    ];
    
  preConfigure = "./autogen.sh"; # install.sh is not contained in the tar

  meta = {
    description = "modular program to synchronize calendars, addressbooks and other PIM data between pcs, mobile devices etc";
  };
}

