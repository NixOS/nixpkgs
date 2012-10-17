{ stdenv, fetchurl, aspell, qt4, zlib, sox, libX11, xproto, libSM
, libICE, qca2, pkgconfig, qca2_ossl, liboil, speex, callPackage, which, glib
, libXScrnSaver, scrnsaverproto
}:

stdenv.mkDerivation rec {
  name = "psi-0.15";

  src = fetchurl {
    url = "mirror://sourceforge/psi/${name}.tar.bz2";
    sha256 = "593b5ddd7934af69c245afb0e7290047fd7dedcfd8765baca5a3a024c569c7e6";
  };

  buildInputs =
    [ aspell qt4 zlib sox libX11 xproto libSM libICE
      qca2 qca2_ossl pkgconfig which glib scrnsaverproto libXScrnSaver
    ];

  NIX_CFLAGS_COMPILE="-I${qca2}/include/QtCrypto";

  NIX_LDFLAGS="-lqca";

  psiMedia = callPackage ./psimedia.nix { };

  enableParallelBuilding = true;

  configureFlags = [
    "--with-aspell-inc=${aspell}/include"
    ];

  postInstall = ''
    PSI_PLUGINS="$out/lib/psi/plugins"
    mkdir -p "$PSI_PLUGINS"
    ln -s "${psiMedia}"/share/psi/plugins/*.so "$PSI_PLUGINS"
    PSI_QT_PLUGINS="$out/share/psi"
    mkdir -p "$PSI_QT_PLUGINS"/crypto
    ln -s "${qca2_ossl}"/lib/qt4/plugins/crypto/*.so "$PSI_QT_PLUGINS"/crypto
  '';

  meta = {
    description = "Psi, an XMPP (Jabber) client";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
