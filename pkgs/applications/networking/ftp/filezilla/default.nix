{ lib, stdenv
, fetchurl
, autoreconfHook
, dbus
, gettext
, gnutls
, libfilezilla
, libidn
, nettle
, pkg-config
, pugixml
, sqlite
, tinyxml
, wrapGAppsHook
, wxGTK30
, gtk3
, xdg-utils
}:

stdenv.mkDerivation rec {
  pname = "filezilla";
  version = "3.63.1";

  src = fetchurl {
    url = "https://download.filezilla-project.org/client/FileZilla_${version}_src.tar.bz2";
    hash = "sha256-TgtcD3n0+LykuiHnE7qXuG1bRcRyPeZ7nBDSO/QXo38=";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config wrapGAppsHook ];

  buildInputs = [
    dbus
    gettext
    gnutls
    libfilezilla
    libidn
    nettle
    pugixml
    sqlite
    tinyxml
    wxGTK30
    gtk3
    xdg-utils
  ];

  enableParallelBuilding = true;

  meta = with lib; {
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
