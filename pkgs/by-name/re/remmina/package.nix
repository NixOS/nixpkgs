{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  curl,
  fuse3,
  desktopToDarwinBundle,
  glib,
  gtk3,
  gettext,
  libxkbfile,
  libX11,
  python3,
  freerdp,
  libssh,
  libgcrypt,
  gnutls,
  pcre2,
  libdbusmenu-gtk3,
  libappindicator-gtk3,
  libvncserver,
  libpthreadstubs,
  libXdmcp,
  libxkbcommon,
  libsecret,
  libsoup_3,
  spice-protocol,
  spice-gtk,
  libepoxy,
  at-spi2-core,
  openssl,
  gsettings-desktop-schemas,
  json-glib,
  libsodium,
  harfbuzz,
  wayland,
  # The themes here are soft dependencies; only icons are missing without them.
  adwaita-icon-theme,
  withKf5Wallet ? stdenv.hostPlatform.isLinux,
  libsForQt5,
  withLibsecret ? stdenv.hostPlatform.isLinux,
  withWebkitGtk ? false,
  webkitgtk_4_1,
  withVte ? true,
  vte,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "remmina";
  version = "1.4.41";

  src = fetchFromGitLab {
    owner = "Remmina";
    repo = "Remmina";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0KUwZ81CyuLa05Cwe7wJrTbM1Dp9mAzNBI5pR7FKTOU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    curl
    gsettings-desktop-schemas
    glib
    gtk3
    gettext
    libxkbfile
    libX11
    freerdp
    libssh
    libgcrypt
    gnutls
    pcre2
    libvncserver
    libpthreadstubs
    libXdmcp
    libxkbcommon
    libsoup_3
    spice-protocol
    spice-gtk
    libepoxy
    at-spi2-core
    openssl
    adwaita-icon-theme
    json-glib
    libsodium
    harfbuzz
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fuse3
    libappindicator-gtk3
    libdbusmenu-gtk3
    wayland
  ]
  ++ lib.optionals withLibsecret [ libsecret ]
  ++ lib.optionals withKf5Wallet [ libsForQt5.kwallet ]
  ++ lib.optionals withWebkitGtk [ webkitgtk_4_1 ]
  ++ lib.optionals withVte [ vte ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  cmakeFlags = [
    "-DWITH_FREERDP3=ON"
    "-DWITH_VTE=${if withVte then "ON" else "OFF"}"
    "-DWITH_TELEPATHY=OFF"
    "-DWITH_AVAHI=OFF"
    "-DWITH_KF5WALLET=${if withKf5Wallet then "ON" else "OFF"}"
    "-DWITH_LIBSECRET=${if withLibsecret then "ON" else "OFF"}"
    "-DWITH_WEBKIT2GTK=${if withWebkitGtk then "ON" else "OFF"}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DHAVE_LIBAPPINDICATOR=OFF"
    "-DWITH_CUPS=OFF"
    "-DWITH_ICON_CACHE=OFF"
    # Don't use system installed Python like on GitHub Actions runners
    "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}"
    "-DPYTHON_LIBRARY=${python3}/lib/libpython${python3.pythonVersion}${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default SSL_CERT_DIR "/etc/ssl/certs/"
      --prefix LD_LIBRARY_PATH : "${libX11.out}/lib"
      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
      ''}
      --prefix PATH : "${lib.makeBinPath [ python3 ]}"
    )
  '';

  meta = with lib; {
    license = licenses.gpl2Plus;
    homepage = "https://gitlab.com/Remmina/Remmina";
    changelog = "https://gitlab.com/Remmina/Remmina/-/blob/master/CHANGELOG.md#${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.src.rev
    }";
    description = "Remote desktop client written in GTK";
    mainProgram = "remmina";
    maintainers = with maintainers; [
      bbigras
      melsigl
      ryantm
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
