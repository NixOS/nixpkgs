{ stdenv, fetchurl, qt4, gstreamer, gst_plugins_base, liboil, speex, which
, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "psimedia-1.0.3";

  src = fetchurl {
    url = "http://delta.affinix.com/download/psimedia/${name}.tar.bz2";
    sha256 = "0fxjdz8afh75gfx2msysb1gss6zx578l3224jvc9jhm99w1ii781";
  };

  patches = [ ./glib-2.32.patch ./linux-headers.patch ];

  buildInputs = [ qt4 gstreamer gst_plugins_base liboil speex which glib pkgconfig ];

  configurePhase = ''./configure'';

  postBuild = ''
    TARGET="$out/share/psi/plugins"
    mkdir -p "$TARGET"
    cp gstprovider/*.so "$TARGET"/
  '';

  meta = {
    description = "Psi Media, a plugin to provide Voice/Video over XMPP";
  };
}
