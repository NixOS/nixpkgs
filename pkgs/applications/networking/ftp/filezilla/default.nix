{ stdenv, fetchurl, dbus, gnutls2, wxGTK28, libidn, tinyxml, gettext, pkgconfig, xdg_utils, gtk2, sqlite36 }:

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
  
  buildInputs = [ dbus gnutls2 wxGTK28 libidn tinyxml gettext pkgconfig xdg_utils gtk2 sqlite36 ];
  
  meta = {
    homepage = "http://filezilla-project.org/";
    description = "FileZilla is a cross-platform graphical FTP, FTPS and SFTP client a lot of features, supporting Windows, Linux, Mac OS X and more.";
    license = "GPLv2";
  };
}
