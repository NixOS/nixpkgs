{ stdenv, fetchsvn, cmake, qt, libupnp, gpgme, gnome3, glib, libssh, pkgconfig, protobuf, bzip2
, libXScrnSaver, speex, curl, libxml2, libxslt, sqlcipher }:

stdenv.mkDerivation {
  name = "retroshare-0.6-svn-7445";

  src = fetchsvn {
    url = svn://svn.code.sf.net/p/retroshare/code/trunk;
    rev = 7445;
    sha256 = "1dqh65bn21g7ix752ddrr10kijjdwjgjipgysyxnm90zjmdlx3cc";
  };

  NIX_CFLAGS_COMPILE = "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include -I${libxml2}/include/libxml2 -I${sqlcipher}/include/sqlcipher";

  patchPhase = ''
    # Fix build error
    sed -i 's/UpnpString_get_String(es_event->PublisherUrl)/es_event->PublisherUrl/' \
      libretroshare/src/upnp/UPnPBase.cpp
    # Extensions get installed 
    sed -i "s,/usr/lib/retroshare/extensions6/,$out/share/retroshare," \
      libretroshare/src/rsserver/rsinit.cc
    # Where to find the bootstrap DHT bdboot.txt
    sed -i "s,/usr/share/RetroShare,$out/share/retroshare," \
      libretroshare/src/rsserver/rsaccounts.cc
  '';

  #  sed -i "s,LIBS +=.*sqlcipher.*,LIBS += -lsqlcipher," \
  #    retroshare-gui/src/retroshare-gui.pro \
  #    retroshare-nogui/src/retroshare-nogui.pro

  buildInputs = [ speex qt libupnp gpgme gnome3.libgnome_keyring glib libssh pkgconfig
                  protobuf bzip2 libXScrnSaver curl libxml2 libxslt sqlcipher ];

  configurePhase = ''
    qmake PREFIX=$out DESTDIR=$out RetroShare.pro
  '';

  postInstall = ''
    mkdir -p $out/bin
    mv $out/retroshare-nogui $out/bin
    mv $out/RetroShare $out/bin

    # plugins
    mkdir -p $out/share/retroshare
    mv $out/lib* $out/share/retroshare

    # BT DHT bootstrap
    cp libbitdht/src/bitdht/bdboot.txt $out/share/retroshare
  '';

  meta = with stdenv.lib; {
    description = "";
    homepage = http://retroshare.sourceforge.net/;
    #license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}
