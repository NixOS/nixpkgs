{ lib, stdenv, fetchFromGitLab, fetchpatch, cmake, ninja, pkg-config, wrapGAppsHook
, desktopToDarwinBundle
, glib, gtk3, gettext, libxkbfile, libX11, python3
, freerdp, libssh, libgcrypt, gnutls, vte
, pcre2, libdbusmenu-gtk3, libappindicator-gtk3
, libvncserver, libpthreadstubs, libXdmcp, libxkbcommon
, libsecret, libsoup_3, spice-protocol, spice-gtk, libepoxy, at-spi2-core
, openssl, gsettings-desktop-schemas, json-glib, libsodium, webkitgtk_4_1, harfbuzz
# The themes here are soft dependencies; only icons are missing without them.
, gnome
, withKf5Wallet ? stdenv.isLinux, libsForQt5
, withLibsecret ? stdenv.isLinux
, withVte ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "remmina";
  version = "1.4.31";

  src = fetchFromGitLab {
    owner  = "Remmina";
    repo   = "Remmina";
    rev    = "v${finalAttrs.version}";
    sha256 = "sha256-oEgpav4oQ9Sld9PY4TsutS5xEnhQgOHnpQhDesRFTeQ=";
  };

  patches = [
    # https://gitlab.com/Remmina/Remmina/-/merge_requests/2525
    (fetchpatch {
      url = "https://gitlab.com/Remmina/Remmina/-/commit/2ce153411597035d0f3db5177d703541e09eaa06.patch";
      hash = "sha256-RV/8Ze9aN4dW49Z+y3z0jFs4dyEWu7DK2FABtmse9Hc=";
    })
  ];

  nativeBuildInputs = [ cmake ninja pkg-config wrapGAppsHook ]
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    gsettings-desktop-schemas
    glib gtk3 gettext libxkbfile libX11
    freerdp libssh libgcrypt gnutls
    pcre2
    libvncserver libpthreadstubs libXdmcp libxkbcommon
    libsoup_3 spice-protocol
    spice-gtk
    libepoxy at-spi2-core
    openssl gnome.adwaita-icon-theme json-glib libsodium
    harfbuzz python3
  ] ++ lib.optionals stdenv.isLinux [ libappindicator-gtk3 libdbusmenu-gtk3 webkitgtk_4_1 ]
    ++ lib.optionals withLibsecret [ libsecret ]
    ++ lib.optionals withKf5Wallet [ libsForQt5.kwallet ]
    ++ lib.optionals withVte [ vte ];

  cmakeFlags = [
    "-DWITH_VTE=${if withVte then "ON" else "OFF"}"
    "-DWITH_TELEPATHY=OFF"
    "-DWITH_AVAHI=OFF"
    "-DWITH_KF5WALLET=${if withKf5Wallet then "ON" else "OFF"}"
    "-DWITH_LIBSECRET=${if withLibsecret then "ON" else "OFF"}"
    "-DFREERDP_LIBRARY=${freerdp}/lib/libfreerdp2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DFREERDP_CLIENT_LIBRARY=${freerdp}/lib/libfreerdp-client2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DFREERDP_WINPR_LIBRARY=${freerdp}/lib/libwinpr2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DWINPR_INCLUDE_DIR=${freerdp}/include/winpr2"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DHAVE_LIBAPPINDICATOR=OFF"
    "-DWITH_CUPS=OFF"
    "-DWITH_ICON_CACHE=OFF"
    "-DWITH_WEBKIT2GTK=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin (toString [
    "-DTARGET_OS_IPHONE=0"
    "-DTARGET_OS_WATCH=0"
  ]);

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default SSL_CERT_DIR "/etc/ssl/certs/"
      --prefix LD_LIBRARY_PATH : "${libX11.out}/lib"
      ${lib.optionalString stdenv.isDarwin ''
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
      ''}
    )
  '';

  meta = with lib; {
    license = licenses.gpl2Plus;
    homepage = "https://gitlab.com/Remmina/Remmina";
    description = "Remote desktop client written in GTK";
    maintainers = with maintainers; [ melsigl ryantm ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
