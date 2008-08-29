{ stdenv, fetchurl, pkgconfig, glib, gtk, libmowgli
, libglade, libmcs, gettext, xlibs, dbus_glib
}:

stdenv.mkDerivation {
  name = "audacious-1.5.1";
  
  src = fetchurl {
    url = http://distfiles.atheme.org/audacious-1.5.1.tbz2;
    sha256 = "1s32pdgx85qkrq15wwmvdw7wbcbxcf3nrhqxi6y72aijqm6fjwnz";
  };

  buildInputs = [pkgconfig libglade libmcs gettext dbus_glib];

  propagatedBuildInputs = [glib gtk libmowgli libmcs];

  NIX_LDFLAGS = "-rpath ${xlibs.libX11}/lib";

  # Otherwise we barf with "libgcc_s.so.1 must be installed for
  # pthread_cancel to work" on exit, as it tries to find libgcc_s
  # dynamically.
  dontPatchELF = true;

  preBuild = ''
    ensureDir $out/lib
  '';

  meta = {
    description = "Audacious, a media player forked from the Beep Media Player, which was itself an XMMS fork";
    homepage = http://audacious-media-player.org/;
  };
}
