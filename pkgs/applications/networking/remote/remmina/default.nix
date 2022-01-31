{ lib, stdenv, fetchFromGitLab, cmake, ninja, pkg-config, wrapGAppsHook
, glib, gtk3, gettext, libxkbfile, libX11
, freerdp, libssh, libgcrypt, gnutls
, pcre2, libdbusmenu-gtk3, libappindicator-gtk3
, libvncserver, libpthreadstubs, libXdmcp, libxkbcommon
, libsecret, libsoup, spice-protocol, spice-gtk, libepoxy, at-spi2-core
, openssl, gsettings-desktop-schemas, json-glib, libsodium, webkitgtk, harfbuzz
# The themes here are soft dependencies; only icons are missing without them.
, gnome
}:

with lib;

stdenv.mkDerivation rec {
  pname = "remmina";
  version = "1.4.23";

  src = fetchFromGitLab {
    owner  = "Remmina";
    repo   = "Remmina";
    rev    = "v${version}";
    sha256 = "sha256-MyemiSAMZEa9Ng6WHEyHgrze8YtIbzMCR8CTb86PDsg=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config wrapGAppsHook ];
  buildInputs = [
    gsettings-desktop-schemas
    glib gtk3 gettext libxkbfile libX11
    freerdp libssh libgcrypt gnutls
    pcre2 libdbusmenu-gtk3 libappindicator-gtk3
    libvncserver libpthreadstubs libXdmcp libxkbcommon
    libsecret libsoup spice-protocol spice-gtk libepoxy at-spi2-core
    openssl gnome.adwaita-icon-theme json-glib libsodium webkitgtk
    harfbuzz
  ];

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

  meta = {
    license = licenses.gpl2Plus;
    homepage = "https://gitlab.com/Remmina/Remmina";
    description = "Remote desktop client written in GTK";
    maintainers = with maintainers; [ melsigl ryantm ];
    platforms = platforms.linux;
  };
}
