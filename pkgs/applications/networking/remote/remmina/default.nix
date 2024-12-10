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
  fetchpatch2,
  desktopToDarwinBundle,
  glib,
  gtk3,
  gettext,
  libxkbfile,
  libX11,
  python3,
  freerdp3,
  libssh,
  libgcrypt,
  gnutls,
  vte,
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
  webkitgtk_4_1,
  harfbuzz,
  wayland,
  # The themes here are soft dependencies; only icons are missing without them.
  gnome,
  withKf5Wallet ? stdenv.isLinux,
  libsForQt5,
  withLibsecret ? stdenv.isLinux,
  withVte ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "remmina";
  version = "1.4.35";

  src = fetchFromGitLab {
    owner = "Remmina";
    repo = "Remmina";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0z2fcBnChCBYPxyFm/xpAW0jHaUGA92NQgjt+lWFUnM=";
  };

  patches = [
    (fetchpatch2 {
      name = "add-a-conditional-check-for-darwin-and-NetBSD.patch";
      url = "https://gitlab.com/Remmina/Remmina/-/commit/3b681398c823e070c7f780166b9d9fc2158e66c1.diff";
      hash = "sha256-Ovdrsl9bftXiuXV+sqvDP9VGuXQZzC5VKOmkYmBXhNA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
  ] ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];

  buildInputs =
    [
      curl
      gsettings-desktop-schemas
      glib
      gtk3
      gettext
      libxkbfile
      libX11
      freerdp3
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
      gnome.adwaita-icon-theme
      json-glib
      libsodium
      harfbuzz
      python3
      wayland
    ]
    ++ lib.optionals stdenv.isLinux [
      fuse3
      libappindicator-gtk3
      libdbusmenu-gtk3
      webkitgtk_4_1
    ]
    ++ lib.optionals withLibsecret [ libsecret ]
    ++ lib.optionals withKf5Wallet [ libsForQt5.kwallet ]
    ++ lib.optionals withVte [ vte ];

  cmakeFlags =
    [
      "-DWITH_FREERDP3=ON"
      "-DWITH_VTE=${if withVte then "ON" else "OFF"}"
      "-DWITH_TELEPATHY=OFF"
      "-DWITH_AVAHI=OFF"
      "-DWITH_KF5WALLET=${if withKf5Wallet then "ON" else "OFF"}"
      "-DWITH_LIBSECRET=${if withLibsecret then "ON" else "OFF"}"
    ]
    ++ lib.optionals stdenv.isDarwin [
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
