{ stdenv, fetchurl, dbus, gnutls, wxGTK30, libidn, tinyxml, gettext
, pkgconfig, xdg_utils, gtk2, sqlite }:

let version = "3.12.0.2"; in
stdenv.mkDerivation {
  name = "filezilla-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/FileZilla_Client/${version}/FileZilla_${version}_src.tar.bz2";
    sha256 = "038xgvajn0nq1dzw1pac3xwhmil1y17vhadd2hx0vl4lrp16yabs";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
  ];

  buildInputs = [
    dbus gnutls wxGTK30 libidn tinyxml gettext pkgconfig xdg_utils gtk2 sqlite
  ];

  meta = with stdenv.lib; {
    homepage = http://filezilla-project.org/;
    description = "Graphical FTP, FTPS and SFTP client";
    license = licenses.gpl2;
    longDescription = ''
      FileZilla Client is a free, open source FTP client. It supports
      FTP, SFTP, and FTPS (FTP over SSL/TLS). The client is available
      under many platforms, binaries for Windows, Linux and Mac OS X are
      provided.
    '';
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
