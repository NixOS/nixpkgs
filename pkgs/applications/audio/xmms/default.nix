{stdenv, fetchurl, alsaLib, esound, libogg, libvorbis, glib, gtk}:

stdenv.mkDerivation {
  name = "xmms-1.2.10";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xmms-1.2.10.tar.bz2;
    md5 = "03a85cfc5e1877a2e1f7be4fa1d3f63c";
  };

  # Patch borrowed from SuSE 10.0 to fix pause/continue on ALSA.
  patches = [./alsa.patch];

  buildInputs = [alsaLib esound libogg libvorbis glib gtk];
}
