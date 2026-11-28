{
  lib,
  stdenv,
  fetchurl,

  pkg-config,
  cmake,
  ninja,

  kdePackages,
  libghostty-vt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwi";
  version = "0.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/kwi/${finalAttrs.version}/kwi-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZCluPv87UbHA/c0NJbJEGyBTcqFzMPOt56fmE7SYBqc=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = false; # Requires fontconfig, dbus with a session.conf, etc
  doInstallCheck = true;
  separateDebugInfo = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ (with kdePackages; [
    wrapQtAppsHook
  ]);

  buildInputs = [
    libghostty-vt
  ]
  ++ (with kdePackages; [
    # keep-sorted start
    extra-cmake-modules
    kdbusaddons
    kio
    kirigami
    kirigami-addons
    kirigami-app-components
    knotifications
    kparts
    kpty
    kwindowsystem
    kxmlgui
    qtquick3d
    # keep-sorted end
  ]);

  meta = {
    description = "Modern and fast terminal for KDE Plasma and other desktops";
    homepage = "https://invent.kde.org/utilities/kwi";
    changelog = "https://invent.kde.org/utilities/kwi/-/commits/v${finalAttrs.version}";
    license =
      with lib.licenses;
      (AND [
        # libs
        (OR [
          lgpl21Only
          lgpl3Only
          lgpl3Plus # KDE-Accepted-LGPL
        ])
        # app
        (OR [
          gpl2Only
          gpl3Only
          gpl3Plus # KDE-Accepted-GPL
        ])
      ]);
    maintainers = with lib.maintainers; [ sandarukasa ];
    mainProgram = "kwi";
    platforms = lib.intersectLists libghostty-vt.meta.platforms kdePackages.kwindowsystem.meta.platforms; # crude approximation
  };
})
