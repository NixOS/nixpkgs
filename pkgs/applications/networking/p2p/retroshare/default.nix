{ stdenv, fetchurl, cmake, qt, libupnp, gpgme, gnome3, glib, libssh, pkgconfig, protobuf, bzip2
, libXScrnSaver, speex, curl, libxml2, libxslt }:

stdenv.mkDerivation {
  name = "retroshare-0.5.5c";

  src = fetchurl {
    url = mirror://sourceforge/project/retroshare/RetroShare/0.5.5c/retroshare_0.5.5-0.7068.tar.gz;
    sha256 = "0l2n4pr1hq66q6qa073hrdx3s3d7iw54z8ay1zy82zhk2rwhsavp";
  };

  NIX_CFLAGS_COMPILE = "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include -I${libxml2}/include/libxml2";

  patchPhase = "sed -i 's/UpnpString_get_String(es_event->PublisherUrl)/es_event->PublisherUrl/' libretroshare/src/upnp/UPnPBase.cpp";

  buildInputs = [ speex qt libupnp gpgme gnome3.libgnome_keyring glib libssh pkgconfig
                  protobuf bzip2 libXScrnSaver curl libxml2 libxslt ];

  sourceRoot = "retroshare-0.5.5/src";

  configurePhase = ''
    qmake PREFIX=$out DESTDIR=$out RetroShare.pro
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/retroshare-nogui $out/bin
    ln -s $out/RetroShare $out/bin
  '';

  meta = with stdenv.lib; {
    description = "";
    homepage = http://retroshare.sourceforge.net/;
    #license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}
