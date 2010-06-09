{stdenv, fetchurl, qt4, gst_all, liboil, speex}:

stdenv.mkDerivation rec {
  name = "psimedia";

  src = fetchurl {
    url = "http://delta.affinix.com/download/psimedia/psimedia-1.0.3.tar.bz2";
    sha256 = "0fxjdz8afh75gfx2msysb1gss6zx578l3224jvc9jhm99w1ii781";
  };

  buildInputs = [qt4 gst_all.gstreamer gst_all.gstPluginsBase liboil speex];

  configurePhase = ''./configure'';

  postBuild = ''
    TARGET="$out/share/psi/plugins"
    ensureDir "$TARGET"
    cp gstprovider/*.so "$TARGET"/
  '';

  meta = {
    description = "Psi Media, a plugin to provide Voice/Video over XMPP";
  };
}
