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
, wxGTK30-gtk3
, xdg-utils
}:

stdenv.mkDerivation rec {
  pname = "filezilla";
  version = "3.53.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/client/FileZilla_${version}_src.tar.bz2";
    sha256 = "sha256-MJXnYN9PVADttNqj3hshLElHk2Dy9FzE67clMMh85CA=";
  };

  # https://www.linuxquestions.org/questions/slackware-14/trouble-building-filezilla-3-47-2-1-current-4175671182/#post6099769
  postPatch = ''
    sed -i src/interface/Mainfrm.h \
      -e '/^#define/a #include <list>'
  '';

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

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
    wxGTK30-gtk3
    wxGTK30-gtk3.gtk
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
