{
  lib,
  stdenv,
  fetchsvn,
  autoreconfHook,
  dbus,
  gettext,
  gnutls,
  libfilezilla,
  libidn,
  nettle,
  pkg-config,
  pugixml,
  sqlite,
  tinyxml,
  boost,
  wrapGAppsHook3,
  wxGTK32,
  gtk3,
  xdg-utils,
}:

stdenv.mkDerivation {
  pname = "filezilla";
  version = "3.68.1";

  src = fetchsvn {
    url = "https://svn.filezilla-project.org/svn/FileZilla3/trunk";
    rev = "11205";
    hash = "sha256-izaNfagJYUcPRPihZ1yXwLUTHunzVXuiMITW69KPSFE=";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    boost
    dbus
    gettext
    gnutls
    libfilezilla
    libidn
    nettle
    pugixml
    sqlite
    tinyxml
    wxGTK32
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
