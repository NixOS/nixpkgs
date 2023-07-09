{ lib
, stdenv
, fetchFromGitLab
, cmake
, qtquickcontrols2
, wrapQtAppsHook
, extra-cmake-modules
, kirigami2
, prison
, networkmanager-qt
, ki18n
, kcontacts
, knotifications
, kpurpose
, kio
, kservice
, unstableGitUpdater
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "qrca";
  version = "unstable-2023-07-08";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "qrca";
    rev = "c1024e9c6de76b42d4359db8b0e9e9af2e95052b";
    hash = "sha256-f6mliSJ+0Vmp2jTcIdytQ6IcSe0eEzuhjGS36QiqGFk=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    extra-cmake-modules
  ];

  buildInputs = [
    qtquickcontrols2
    kirigami2
    prison
    ki18n
    kcontacts
    knotifications
    kpurpose
    kio
    kservice
    networkmanager-qt
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  preFixup = ''
    # add gstreamer plugins path to the wrapper
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "QR code scanner for Plasma Mobile";
    homepage = "https://invent.kde.org/utilities/qrca";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ squalus ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
}
