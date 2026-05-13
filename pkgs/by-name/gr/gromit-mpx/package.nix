{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  glib,
  libappindicator-gtk3,
  libpthread-stubs,
  libxdmcp,
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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "bk138";
    repo = "gromit-mpx";
    tag = finalAttrs.version;
    hash = "sha256-DgPhQtLmrhcRInaY4s23izWte86DczprjnWhfiiYsSE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    libappindicator-gtk3
    libpthread-stubs
    libxdmcp
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
