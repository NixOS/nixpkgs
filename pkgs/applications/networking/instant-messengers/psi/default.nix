{ stdenv, fetchurl, aspell, qt4, zlib, sox, libX11, xproto, libSM, 
  libICE, qca2, pkgconfig, qca2_ossl, liboil, speex, gst_all }:

stdenv.mkDerivation rec {
  name = "psi-0.14";
  
  src = fetchurl {
    url = "mirror://sourceforge/psi/${name}.tar.bz2";
    sha256 = "1h54a1qryfva187sw9qnb4lv1d3h3lysqgw55v727swvslh4l0da";
  };

  buildInputs = [aspell qt4 zlib sox libX11 xproto libSM libICE 
    qca2 qca2_ossl pkgconfig];

  NIX_CFLAGS_COMPILE="-I${qca2}/include/QtCrypto";
  
  NIX_LDFLAGS="-lqca";

  configureFlags =
    [ " --with-zlib-inc=${zlib}/include "
      " --disable-bundled-qca"
    ];

  psiMedia = (import ./psimedia.nix) {
    inherit stdenv fetchurl qt4 speex gst_all liboil;
  };

  postInstall = ''
    PSI_PLUGINS="$out/lib/psi/plugins"
    ensureDir "$PSI_PLUGINS"
    ln -s "${psiMedia}"/share/psi/plugins/*.so "$PSI_PLUGINS"
    PSI_QT_PLUGINS="$out/share/psi"
    ensureDir "$PSI_QT_PLUGINS"/crypto
    ln -s "${qca2_ossl}"/lib/qt4/plugins/crypto/*.so "$PSI_QT_PLUGINS"/crypto
  '';

  meta = {
    description = "Psi, an XMPP (Jabber) client";
    maintainers = with stdenv.lib.maintainers;
      [raskin];
    platforms = with stdenv.lib.platforms;
      linux;
  };
}
