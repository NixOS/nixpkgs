{ stdenv, fetchurl, dbus, gnutls, wxGTK28, libidn, tinyxml, gettext
, pkgconfig, xdg_utils, gtk2, sqlite }:

let version = "3.8.1"; in
stdenv.mkDerivation {
  name = "filezilla-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/FileZilla_Client/${version}/FileZilla_${version}_src.tar.bz2";
    sha256 = "0kqyz8yb15kbzx02l3riswg95prbp402k4672nwxrzs35049rg36";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
  ];

  buildInputs = [
    dbus gnutls wxGTK28 libidn tinyxml gettext pkgconfig xdg_utils gtk2 sqlite
  ];

  meta = with stdenv.lib; {
    homepage = "http://filezilla-project.org/";
    description = "Graphical FTP, FTPS and SFTP client";
    license = licenses.gpl2;
    longDescription = ''
      FileZilla Client is a free, open source FTP client. It supports
      FTP, SFTP, and FTPS (FTP over SSL/TLS). The client is available
      under many platforms, binaries for Windows, Linux and Mac OS X are
      provided.
    '';
    platforms = platforms.linux;
  };
}
