{ stdenv, fetchurl, dbus, gnutls, wxGTK30, libidn, tinyxml, gettext
, pkgconfig, xdg_utils, gtk2, sqlite, pugixml, libfilezilla, nettle }:

let version = "3.22.2.2"; in
stdenv.mkDerivation {
  name = "filezilla-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/FileZilla_Client/${version}/FileZilla_${version}_src.tar.bz2";
    sha256 = "1h02k13x88f04gkf433cxx1xvbr7kkl2aygb4i6581gzhzjifwdv";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    dbus gnutls wxGTK30 libidn tinyxml gettext xdg_utils gtk2 sqlite
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
