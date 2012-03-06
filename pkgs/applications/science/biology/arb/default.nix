{ stdenv, fetchurl, glew, mesa, libpng, lesstif, lynx, freeglut
, libtiff, rxp, sablotron, perl, jdk, transfig, gv, gnuplot, xorg }:

# NOTE: This package does not build on 64-bit systems. Because of some faulty
# int->pointer arithmatic. The build scripts are abnormal - but it appears to
# work.

stdenv.mkDerivation {
  name = "arb-2007-Dec-07";
  
  src = fetchurl {
    url = http://download.arb-home.de/release/2007_12_07/arbsrc.tgz;
    sha256 = "04l7qj0wigg1h56a9d70hxhdr343v3dg5dhqrc7fahc1v4h8f1rd";
  };

  patches = [ ./makefile.patch ];

  buildInputs =
    [ glew mesa libpng xorg.libXpm lesstif lynx freeglut libtiff rxp
      sablotron xorg.libXaw perl jdk transfig xorg.libX11 xorg.libXext
      xorg.libXt gv gnuplot
    ];

  unpackPhase = ''
    tar xzf $src
  '';

  buildPhase = ''
    echo `make`   # avoids error signal
    export ARBHOME=`pwd`
    export PATH=$ARBHOME/bin:$PATH
    make all
  '';

  installPhase = ''
    mkdir -p $out/lib
    shareddir=/nix/var/lib/arb
    # link out writable shared location lib/pts
    mkdir -p $shareddir/lib/pts
    cp -vau lib/pts $shareddir/lib
    rm -vrf lib/pts
    ln -vs $shareddir/lib/pts $out/lib/pts
    chmod a+rwx $shareddir/lib/pts
    # link out writable shared location lib/nas/
    mkdir -p $shareddir/lib/nas
    cp -vau lib/nas $shareddir/lib
    rm -vrf lib/nas
    ln -vs $shareddir/lib/nas $out/lib/nas
    chmod a+rwx $shareddir/lib/nas
    # link out shared lib/pixmaps (not sure about this, yet):
    mkdir -p $shareddir/lib/pixmaps
    cp -vau lib/pixmaps $shareddir/lib
    rm -vrf lib/pixmaps
    ln -vs $shareddir/lib/pixmaps $out/lib/pixmaps
    chmod a+rwx $shareddir/lib/pixmaps
    # bulk copy
    cp -vau * $out
    
    # replace arb script
    mv $out/bin/arb $out/bin/arb.orig
    cat > $out/bin/arb << ARB 
    #!/bin/sh

    echo Starting Nix compiled arb from $out
    echo Shared databases are located in $shareddir
    # sometimes local profiles override these:
    export ARBHOME=$out
    export LD_LIBRARY=$ARBHOME/lib   

    $out/bin/arb_ntree $*

    ARB
    
    chmod +x $out/bin/arb
  '';

  meta = {
    description     = "ARB software for sequence database handling and analysis";
    longDescription = ''The ARB software is a graphically oriented package comprising various tools for sequence database handling and data analysis. A central database of processed (aligned) sequences and any type of additional data linked to the respective sequence entries is structured according to phylogeny or other user defined criteria. Note that this package includes its own older versions of clustal etc.''; 
    license     = "non-free";
    pkgMaintainer = "http://BioLib.open-bio.org/";
    homepage    = http://www.arb-home.de/;
    priority    = "10";   # because it includes binaries of clustal etc.
  };
}
