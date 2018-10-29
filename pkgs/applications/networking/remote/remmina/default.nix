{ stdenv, fetchFromGitLab, cmake, pkgconfig, wrapGAppsHook
, glib, gtk3, gettext, libxkbfile, libX11
, freerdp, libssh, libgcrypt, gnutls, makeDesktopItem
, pcre, libdbusmenu-gtk3, libappindicator-gtk3
, libvncserver, libpthreadstubs, libXdmcp, libxkbcommon
, libsecret, libsoup, spice-protocol, spice-gtk, epoxy, at-spi2-core
, openssl, gsettings-desktop-schemas, json-glib
# The themes here are soft dependencies; only icons are missing without them.
, hicolor-icon-theme, adwaita-icon-theme
, gnomeSupport ? true, libgnome-keyring
}:

with stdenv.lib;

let

  desktopItem = makeDesktopItem {
    name = "remmina";
    desktopName = "Remmina";
    genericName = "Remmina Remote Desktop Client";
    exec = "remmina";
    icon = "remmina";
    comment = "Connect to remote desktops";
    categories = "GTK;GNOME;X-GNOME-NetworkSettings;Network;";
  };

in stdenv.mkDerivation rec {
  name = "remmina-${version}";
  version = "1.2.32";

  src = fetchFromGitLab {
    owner  = "Remmina";
    repo   = "Remmina";
    rev    = "v${version}";
    sha256 = "15szv1xs6drxq6qyksmxcfdz516ja4zm52r4yf6hwij3fgl8qdpw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake wrapGAppsHook gsettings-desktop-schemas
    glib gtk3 gettext libxkbfile libX11
    freerdp libssh libgcrypt gnutls
    pcre libdbusmenu-gtk3 libappindicator-gtk3
    libvncserver libpthreadstubs libXdmcp libxkbcommon
    libsecret libsoup spice-protocol spice-gtk epoxy at-spi2-core
    openssl hicolor-icon-theme adwaita-icon-theme json-glib
  ]
  ++ optional gnomeSupport libgnome-keyring;

  preConfigure = optionalString (!gnomeSupport) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(remmina-plugins-gnome)" ""
  '';

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

  meta = {
    license = stdenv.lib.licenses.gpl2;
    homepage = https://gitlab.com/Remmina/Remmina;
    description = "Remote desktop client written in GTK+";
    maintainers = with maintainers; [ melsigl ryantm ];
    platforms = platforms.linux;
  };
}
