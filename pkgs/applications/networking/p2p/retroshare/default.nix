{stdenv, fetchurl, qt, libupnp, gpgme, libgnome_keyring, glib}:

throw "still fails to build"

stdenv.mkDerivation {
  name = "retroshare-0.5.1d";

  src = fetchurl {
    url = mirror://sourceforge/retroshare/RetroShare-v0.5.1d.tar.gz;
    sha256 = "15971wxx8djwcxn170jyn0mlh7cfzqsf031aa849wr9z234gwrcn";
  };

  buildInputs = [ qt libupnp gpgme libgnome_keyring glib ];

  buildPhase = ''
    cd libbitdht/src
    qmake libbitdht.pro PREFIX=$out
    make
    cd ../..
    cd libretroshare/src
    qmake libretroshare.pro PREFIX=$out
    make
    cd ../../src
    qmake libretroshare.pro PREFIX=$out
    make
  '';

}
