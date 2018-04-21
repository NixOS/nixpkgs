{ stdenv, fetchFromGitHub, cmake, pkgconfig, wrapGAppsHook
, glib, gtk3, gettext, libxkbfile, libgnome-keyring, libX11
, freerdp, libssh, libgcrypt, gnutls, makeDesktopItem
, pcre, webkitgtk, libdbusmenu-gtk3, libappindicator-gtk3
, libvncserver, libpthreadstubs, libXdmcp, libxkbcommon
, libsecret, spice-protocol, spice-gtk, epoxy, at-spi2-core
, openssl, gsettings-desktop-schemas
# The themes here are soft dependencies; only icons are missing without them.
, hicolor-icon-theme, adwaita-icon-theme
}:

let
  version = "1.2.0-rcgit.24";

  desktopItem = makeDesktopItem {
    name = "remmina";
    desktopName = "Remmina";
    genericName = "Remmina Remote Desktop Client";
    exec = "remmina";
    icon = "remmina";
    comment = "Connect to remote desktops";
    categories = "GTK;GNOME;X-GNOME-NetworkSettings;Network;";
  };

in stdenv.mkDerivation {
  name = "remmina-${version}";

  src = fetchFromGitHub {
    owner  = "FreeRDP";
    repo   = "Remmina";
    rev    = "v${version}";
    sha256 = "1x7kygl9a5nh7rf2gfrk0wwv23mbw7rrjms402l3zp1w53hrhwmg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake wrapGAppsHook gsettings-desktop-schemas
                  glib gtk3 gettext libxkbfile libgnome-keyring libX11
                  freerdp libssh libgcrypt gnutls
                  pcre webkitgtk libdbusmenu-gtk3 libappindicator-gtk3
                  libvncserver libpthreadstubs libXdmcp libxkbcommon
                  libsecret spice-protocol spice-gtk epoxy at-spi2-core
                  openssl hicolor-icon-theme adwaita-icon-theme ];

  cmakeFlags = [
    "-DWITH_VTE=OFF"
    "-DWITH_TELEPATHY=OFF"
    "-DWITH_AVAHI=OFF"
    "-DFREERDP_LIBRARY=${freerdp}/lib/libfreerdp2.so"
    "-DFREERDP_CLIENT_LIBRARY=${freerdp}/lib/libfreerdp-client2.so"
    "-DFREERDP_WINPR_LIBRARY=${freerdp}/lib/libwinpr2.so"
    "-DWINPR_INCLUDE_DIR=${freerdp}/include/winpr2"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${libX11.out}/lib"
    )
  '';

  postInstall = ''
    mkdir -pv $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = with stdenv.lib; {
    license = stdenv.lib.licenses.gpl2;
    homepage = http://remmina.sourceforge.net/;
    description = "Remote desktop client written in GTK+";
    maintainers = [];
    platforms = platforms.linux;
  };
}
