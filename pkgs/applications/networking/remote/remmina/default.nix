{ lib, stdenv, fetchFromGitLab, cmake, ninja, pkg-config, wrapGAppsHook
, glib, gtk3, gettext, libxkbfile, libX11, python3
, freerdp, libssh, libgcrypt, gnutls, vte
, pcre2, libdbusmenu-gtk3, libappindicator-gtk3
, libvncserver, libpthreadstubs, libXdmcp, libxkbcommon
, libsecret, libsoup_3, spice-protocol, spice-gtk, libepoxy, at-spi2-core
, openssl, gsettings-desktop-schemas, json-glib, libsodium, webkitgtk_4_1, harfbuzz
# The themes here are soft dependencies; only icons are missing without them.
, gnome
<<<<<<< HEAD
, withKf5Wallet ? stdenv.isLinux, libsForQt5
, withLibsecret ? stdenv.isLinux
, withVte ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "remmina";
  version = "1.4.31";
=======
, withKf5Wallet ? true, libsForQt5
, withLibsecret ? true
, withVte ? true
}:

stdenv.mkDerivation rec {
  pname = "remmina";
  version = "1.4.30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner  = "Remmina";
    repo   = "Remmina";
<<<<<<< HEAD
    rev    = "v${finalAttrs.version}";
    sha256 = "sha256-oEgpav4oQ9Sld9PY4TsutS5xEnhQgOHnpQhDesRFTeQ=";
=======
    rev    = "v${version}";
    sha256 = "sha256-VYBolB6VJ3lT/rNl87qMW5DU5rdFCNvKezSLzx5y1JI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ninja pkg-config wrapGAppsHook ];

  buildInputs = [
    gsettings-desktop-schemas
    glib gtk3 gettext libxkbfile libX11
    freerdp libssh libgcrypt gnutls
<<<<<<< HEAD
    pcre2
=======
    pcre2 libdbusmenu-gtk3 libappindicator-gtk3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libvncserver libpthreadstubs libXdmcp libxkbcommon
    libsoup_3 spice-protocol
    spice-gtk
    libepoxy at-spi2-core
<<<<<<< HEAD
    openssl gnome.adwaita-icon-theme json-glib libsodium
    harfbuzz python3
  ] ++ lib.optionals stdenv.isLinux [ libappindicator-gtk3 libdbusmenu-gtk3 webkitgtk_4_1 ]
    ++ lib.optionals withLibsecret [ libsecret ]
=======
    openssl gnome.adwaita-icon-theme json-glib libsodium webkitgtk_4_1
    harfbuzz python3
  ] ++ lib.optionals withLibsecret [ libsecret ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ lib.optionals withKf5Wallet [ libsForQt5.kwallet ]
    ++ lib.optionals withVte [ vte ];

  cmakeFlags = [
    "-DWITH_VTE=${if withVte then "ON" else "OFF"}"
    "-DWITH_TELEPATHY=OFF"
    "-DWITH_AVAHI=OFF"
    "-DWITH_KF5WALLET=${if withKf5Wallet then "ON" else "OFF"}"
    "-DWITH_LIBSECRET=${if withLibsecret then "ON" else "OFF"}"
<<<<<<< HEAD
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

=======
    "-DFREERDP_LIBRARY=${freerdp}/lib/libfreerdp2.so"
    "-DFREERDP_CLIENT_LIBRARY=${freerdp}/lib/libfreerdp-client2.so"
    "-DFREERDP_WINPR_LIBRARY=${freerdp}/lib/libwinpr2.so"
    "-DWINPR_INCLUDE_DIR=${freerdp}/include/winpr2"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
<<<<<<< HEAD
      --set-default SSL_CERT_DIR "/etc/ssl/certs/"
      --prefix LD_LIBRARY_PATH : "${libX11.out}/lib"
      ${lib.optionalString stdenv.isDarwin ''
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
      ''}
=======
      --prefix LD_LIBRARY_PATH : "${libX11.out}/lib"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    )
  '';

  meta = with lib; {
    license = licenses.gpl2Plus;
    homepage = "https://gitlab.com/Remmina/Remmina";
    description = "Remote desktop client written in GTK";
    maintainers = with maintainers; [ melsigl ryantm ];
<<<<<<< HEAD
    platforms = platforms.linux ++ platforms.darwin;
  };
})
=======
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
