{ stdenv, fetchurl, dbus, gnutls2, wxGTK28, libidn, tinyxml, gettext, pkgconfig, xdg_utils, gtk2, sqlite }:

let version = "3.6.0.2"; in
stdenv.mkDerivation {
  name = "filezilla-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/FileZilla_Client/${version}/FileZilla_${version}_src.tar.bz2";
    sha256 = "01n6k1q21i21451rdx3rgc4hhxghdn5b0ldzpjsp44ipgww5wsjk";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
  ];

  buildInputs = [ dbus gnutls2 wxGTK28 libidn tinyxml gettext pkgconfig xdg_utils gtk2 sqlite ];

  meta = {
    homepage = "http://filezilla-project.org/";
    description = "Graphical FTP, FTPS and SFTP client";
    license = "GPLv2";

    longDescription = ''
      FileZilla Client is a free, open source FTP client. It supports
      FTP, SFTP, and FTPS (FTP over SSL/TLS). The client is available
      under many platforms, binaries for Windows, Linux and Mac OS X are
      provided.
    '';
  };
}
