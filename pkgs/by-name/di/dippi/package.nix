{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "dippi";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "dippi";
    rev = version;
    hash = "sha256-BYI3WqMDxzERlqtq7ISQ+U1FTrpKh5OJBMo/AsdmdlQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = {
    description = "Calculate display info like DPI and aspect ratio";
    homepage = "https://github.com/cassidyjames/dippi";
    mainProgram = "com.github.cassidyjames.dippi";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
