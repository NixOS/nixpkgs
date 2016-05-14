{ stdenv, fetchurl, dbus, gnutls, wxGTK30, libidn, tinyxml, gettext
, pkgconfig, xdg_utils, gtk2, sqlite, pugixml, libfilezilla, nettle }:

let version = "3.17.0.1"; in
stdenv.mkDerivation {
  name = "filezilla-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/FileZilla_Client/${version}/FileZilla_${version}_src.tar.bz2";
    sha256 = "0ai3a0nys3yjmlvlv57nli77x6x0a2r409b4f5w4kr9mi6f4z4a7";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
  ];

  buildInputs = [
    dbus gnutls wxGTK30 libidn tinyxml gettext pkgconfig xdg_utils gtk2 sqlite
    pugixml libfilezilla nettle ];

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
