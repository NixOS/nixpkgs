{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  gtk3,
  libwnck,
  libfakekey,
  libxtst,
  mate-panel,
  wrapGAppsHook3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-netbook";
  version = "1.26.0";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-netbook-${finalAttrs.version}.tar.xz";
    sha256 = "12gdy69nfysl8vmd8lv8b0lknkaagplrrz88nh6n0rmjkxnipgz3";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libwnck
    libfakekey
    libxtst
    mate-panel
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-netbook";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "MATE utilities for netbooks";
    mainProgram = "mate-maximus";
    longDescription = ''
      MATE utilities for netbooks are an applet and a daemon to maximize
      windows and move their titles on the panel.

      Installing these utilities is recommended for netbooks and similar
      devices with low resolution displays.
    '';
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl3Only
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
