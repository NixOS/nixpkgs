{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  kdePackages,
  ctestCheckHook,
  withGstreamer ? true,
  gst_all_1,
  withOmemo ? true,
  libomemo-c,
  withEncryption ? true,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qxmpp";
  version = "1.17.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "qxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ahuOGVofKI3u35BgplHBI7xXnZYGWFR0PQwxE5Gqi5Q=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ]
  ++ lib.optionals (withGstreamer || withOmemo) [
    pkg-config
  ];
  buildInputs =
    lib.optionals withGstreamer (
      with gst_all_1;
      [
        gstreamer
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
      ]
    )
    ++ lib.optionals withOmemo [
      kdePackages.qtbase
      kdePackages.qca
      libomemo-c
    ];
  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCUMENTATION" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_OMEMO" withOmemo)
    (lib.cmakeBool "WITH_ENCRYPTION" withEncryption)
    (lib.cmakeBool "WITH_GSTREAMER" withGstreamer)
  ];

  doCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];
  disabledTests = [
    "tst_IceConnection"
    "tst_FileSharing"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform C++ XMPP client and server library";
    changelog = "https://invent.kde.org/libraries/qxmpp/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://invent.kde.org/libraries/qxmpp";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      astro
      haansn08
    ];
    platforms = with lib.platforms; linux;
  };
})
