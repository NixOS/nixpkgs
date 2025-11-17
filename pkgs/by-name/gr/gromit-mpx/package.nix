{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  gtk3,
  glib,
  libappindicator-gtk3,
  libpthreadstubs,
  xorg,
  libxkbcommon,
  libepoxy,
  at-spi2-core,
  dbus,
  libdbusmenu,
  lz4,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gromit-mpx";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bk138";
    repo = "gromit-mpx";
    tag = finalAttrs.version;
    hash = "sha256-jHw4V2ZvfpT3PUihe/O+9BPsv+udFg5seMbYmxOz8Yk=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/bk138/gromit-mpx/commit/e3b501d497374da083b97d0b3bbd40c5c766d2d1.patch?full_index=1";
      hash = "sha256-MJFwwYuvIZeLJBi4p/JQ6qJo6fntj2Q7y+ufap/MGdY=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    libappindicator-gtk3
    libpthreadstubs
    xorg.libXdmcp
    libxkbcommon
    libepoxy
    at-spi2-core
    dbus
    libdbusmenu
    lz4
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop annotation tool";
    longDescription = ''
      Gromit-MPX (GRaphics Over MIscellaneous Things) is a small tool
      to make annotations on the screen.
    '';
    homepage = "https://github.com/bk138/gromit-mpx";
    changelog = "https://github.com/bk138/gromit-mpx/blob/${finalAttrs.version}/NEWS.md";
    maintainers = with lib.maintainers; [
      pjones
      gepbird
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    mainProgram = "gromit-mpx";
  };
})
