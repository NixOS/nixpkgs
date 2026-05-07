{
  lib,
  stdenv,
  fetchFromGitLab,
  nix-update-script,
  nixosTests,

  # build
  cmake,
  extra-cmake-modules,
  kdePackages,
  pkg-config,
  writableTmpDirAsHomeHook,

  # runtime
  gst_all_1,
  kdsingleapplication,
  qxmpp,
  zxing-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kaidan";
  version = "0.14.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = "kaidan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lKJU8GIkubHLYsP7r+TA+1rg+TMGONwjEcys19f62/w=";
  };

  patches = [
    ./0001-Fix-compatibility-with-qt-6.10.patch
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdePackages.wrapQtAppsHook
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    (gst_all_1.gst-plugins-good.override { qt6Support = true; })
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    kdePackages.kio
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.knotifications
    kdePackages.kquickimageeditor
    kdePackages.prison
    kdePackages.qqc2-desktop-style
    kdePackages.qtbase
    kdePackages.qtkeychain
    kdePackages.qtlocation
    kdePackages.qtmultimedia
    kdePackages.qttools
    kdePackages.sonnet
    kdsingleapplication
    qxmpp
    zxing-cpp
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
  ];

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests.kaidan = nixosTests.kaidan;

  meta = {
    description = "User-friendly and modern chat app, using XMPP";
    mainProgram = "kaidan";
    longDescription = ''
      Kaidan is a user-friendly and modern chat app for every device. It uses
      the open communication protocol XMPP (Jabber). Unlike other chat apps,
      you are not dependent on one specific service provider.

      Kaidan does not have all basic features yet and has still some
      stability issues. Current features include audio messages, video
      messages, and file sharing.
    '';
    homepage = "https://www.kaidan.im";
    license = with lib.licenses; [
      gpl3Plus
      mit
      asl20
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ astro ];
    teams = with lib.teams; [ ngi ];
    platforms = with lib.platforms; linux;
  };
})
