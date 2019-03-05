{ stdenv, fetchurl, dbus, gnutls, wxGTK30, libidn, tinyxml, gettext
, pkgconfig, xdg_utils, sqlite, pugixml, libfilezilla }:

stdenv.mkDerivation rec {
  name = "filezilla-${version}";
  version = "3.40.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/client/FileZilla_${version}_src.tar.bz2";
    sha256 = "11b0410fcwrahq5dd7ph10bc09m62sxra4bjp0kj5gph822s0v63";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
  ];

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [
    dbus gnutls wxGTK30 libidn tinyxml xdg_utils wxGTK30.gtk sqlite
    pugixml libfilezilla ];

  enableParallelBuilding = true;

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
