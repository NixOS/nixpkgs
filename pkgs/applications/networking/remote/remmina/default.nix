{ stdenv, fetchFromGitLab, cmake, pkgconfig, wrapGAppsHook
, glib, gtk3, gettext, libxkbfile, libgnome-keyring, libX11
, freerdp, libssh, libgcrypt, gnutls, makeDesktopItem
, pcre, webkitgtk, libdbusmenu-gtk3, libappindicator-gtk3
, libvncserver, libpthreadstubs, libXdmcp, libxkbcommon
, libsecret, spice-protocol, spice-gtk, epoxy, at-spi2-core
, openssl, gsettings-desktop-schemas, json-glib
# The themes here are soft dependencies; only icons are missing without them.
, hicolor-icon-theme, adwaita-icon-theme
}:

let
  version = "1.2.31.4";

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

  src = fetchFromGitLab {
    owner  = "Remmina";
    repo   = "Remmina";
    rev    = "v${version}";
    sha256 = "1jx704f5zjns3nqy0ffgyfaxfxcxp83mfm5k539xfnqjn5g5h1qr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake wrapGAppsHook gsettings-desktop-schemas
                  glib gtk3 gettext libxkbfile libgnome-keyring libX11
                  freerdp libssh libgcrypt gnutls
                  pcre webkitgtk libdbusmenu-gtk3 libappindicator-gtk3
                  libvncserver libpthreadstubs libXdmcp libxkbcommon
                  libsecret spice-protocol spice-gtk epoxy at-spi2-core
                  openssl hicolor-icon-theme adwaita-icon-theme json-glib ];

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
    homepage = https://gitlab.com/Remmina/Remmina;
    description = "Remote desktop client written in GTK+";
    maintainers = with maintainers; [ melsigl ryantm ];
    platforms = platforms.linux;
  };
}
