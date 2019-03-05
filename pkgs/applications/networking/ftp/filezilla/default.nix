{ stdenv, fetchsvn, autoconf, automake, libtool
,  dbus, gnutls, wxGTK30, libidn, tinyxml, gettext
, pkgconfig, xdg_utils, gtk2, sqlite, pugixml, libfilezilla, nettle }:

stdenv.mkDerivation rec {
  name = "filezilla-${version}";
  version = "3.40.0";

  src = fetchsvn {
    url = "https://svn.filezilla-project.org/svn/FileZilla3/tags/${version}";
    sha256 = "0sxik1kjyjbpjkf74yzp9lmi6sxmrqqd3a2y3nz7ampyr1ayv5dz";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
  ];

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];
  buildInputs = [
    dbus gnutls wxGTK30 libidn tinyxml gettext xdg_utils gtk2 sqlite
    pugixml libfilezilla nettle ];

  preConfigure = ''
    autoreconf -i
    '';

  meta = with stdenv.lib; {
    homepage = https://filezilla-project.org/;
    description = "Graphical FTP, FTPS and SFTP client";
    license = licenses.gpl2;
    longDescription = ''
      FileZilla Client is a free, open source FTP client. It supports
      FTP, SFTP, and FTPS (FTP over SSL/TLS). The client is available
      under many platforms, binaries for Windows, Linux and macOS are
      provided.
    '';
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
