{ stdenv, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, glib, gtk3, gettext, libxkbfile, libgnome_keyring, libX11
, freerdp, libssh, libgcrypt, gnutls, makeDesktopItem
, pcre, webkitgtk, libdbusmenu-gtk3, libappindicator-gtk3
, libvncserver, libpthreadstubs, libXdmcp, libxkbcommon
, libsecret, spice_protocol, spice_gtk, epoxy, at_spi2_core
, openssl }:

let
  version = "1.2.0-rcgit.15";
  
  desktopItem = makeDesktopItem {
    name = "remmina";
    desktopName = "Remmina";
    genericName = "Remmina Remote Desktop Client";
    exec = "remmina";
    icon = "remmina";
    comment = "Connect to remote desktops";
    categories = "GTK;GNOME;X-GNOME-NetworkSettings;Network;";
  };

  # Latest release of remmina refers to thing that aren't yet in
  # a FreeRDP release so we need to build one from git source
  # See also https://github.com/FreeRDP/Remmina/pull/731
  # Remove when FreeRDP release catches up with this commit
  freerdp_git = stdenv.lib.overrideDerivation freerdp (args: {
    name = "freerdp-git-2016-09-30";
    src = fetchFromGitHub {
      owner  = "FreeRDP";
      repo   = "FreeRDP";
      rev    = "dbb353db92e7a5cb0be3c73aa950fb1113e627ec";
      sha256 = "1nhm4v6z9var9hasp4bkmhvlrksbdizx95swx19shizfc82s9g4y";
    };
  });

in

stdenv.mkDerivation {
  name = "remmina-${version}";

  src = fetchFromGitHub {
    owner  = "FreeRDP";
    repo   = "Remmina";
    rev    = "v${version}";
    sha256 = "07lj6a7x9cqcff18pwfkx8c8iml015zp6sq29dfcxpfg4ai578h0";
  };

  buildInputs = [ cmake pkgconfig makeWrapper
                  glib gtk3 gettext libxkbfile libgnome_keyring libX11
                  freerdp_git libssh libgcrypt gnutls
                  pcre webkitgtk libdbusmenu-gtk3 libappindicator-gtk3
                  libvncserver libpthreadstubs libXdmcp libxkbcommon
                  libsecret spice_protocol spice_gtk epoxy at_spi2_core
                  openssl ];

  cmakeFlags = "-DWITH_VTE=OFF -DWITH_TELEPATHY=OFF -DWITH_AVAHI=OFF -DWINPR_INCLUDE_DIR=${freerdp_git}/include/winpr2";

  postInstall = ''
    mkdir -pv $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    wrapProgram $out/bin/remmina --prefix LD_LIBRARY_PATH : "${libX11.out}/lib"
  '';

  meta = with stdenv.lib; {
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://remmina.sourceforge.net/";
    description = "Remote desktop client written in GTK+";
    maintainers = [];
    platforms = platforms.linux;
  };
}
