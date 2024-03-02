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
, boost
, wrapGAppsHook
, wxGTK32
, gtk3
, xdg-utils
, CoreServices
, Security
}:

stdenv.mkDerivation rec {
  pname = "filezilla";
  version = "3.66.4";

  src = fetchurl {
    url = "https://download.filezilla-project.org/client/FileZilla_${version}_src.tar.xz";
    hash = "sha256-pA8E4C76rntQ0VFe4cNsSw5EWBhWbEUORAv9bHDpsgM=";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config wrapGAppsHook ];

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
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  preBuild = lib.optionalString (stdenv.isDarwin) ''
    export MACOSX_DEPLOYMENT_TARGET=11.0
  '';

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
