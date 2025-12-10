{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  pkg-config,
  kdePackages,
  kdsingleapplication,
  zxing-cpp,
  qxmpp,
  gst_all_1,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kaidan";
  version = "0.13.0-unstable-2025-12-09";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = "kaidan";
    rev = "d160f34ce1fecb39f4c71530cf2d4ba57bfbd6f4";
    hash = "sha256-/Nt6XjauaVKdLSZglk3qfd0wxW/VpwzMnVwuF/jGP0s=";
  };

  patches = [
    ./0001-Fix-compatibility-with-qt-6.10.patch
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kio
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.knotifications
    kdePackages.kquickimageedit
    kdePackages.prison
    kdePackages.qtbase
    kdePackages.qtkeychain
    kdePackages.qttools
    kdePackages.qtmultimedia
    kdePackages.qtlocation
    kdePackages.qqc2-desktop-style
    kdePackages.sonnet
    kdsingleapplication
    zxing-cpp
    qxmpp
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { qt6Support = true; })
  ];
  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

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
