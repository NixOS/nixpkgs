{ stdenv
, fetchurl

, dbus
, gettext
, gnutls
, gtk2
, libfilezilla
, libidn
, nettle
, pkgconfig
, pugixml
, sqlite
, tinyxml
, wxGTK30
, xdg_utils
}:

stdenv.mkDerivation rec {
  pname = "filezilla";
  version = "3.46.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/client/FileZilla_${version}_src.tar.bz2";
    sha256 = "0v7656p7b6w88a96wj8058b13yxbwi186l092i9whrisngnv2pnf";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    dbus
    gettext
    gnutls
    gtk2
    libfilezilla
    libidn
    nettle
    pugixml
    sqlite
    tinyxml
    wxGTK30
    xdg_utils
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://filezilla-project.org/";
    description = "Graphical FTP, FTPS and SFTP client";
    longDescription = ''
      FileZilla Client is a free, open source FTP client. It supports
      FTP, SFTP, and FTPS (FTP over SSL/TLS). The client is available
      under many platforms, binaries for Windows, Linux and macOS are
      provided.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
