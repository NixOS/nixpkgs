{
  lib,
  stdenv,
  cmake,
  fetchurl,
  gettext,
  gst_all_1,
  ninja,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcompris";
  version = "25.1.1";

  src = fetchurl {
    url = "mirror://kde/stable/gcompris/qt/src/gcompris-qt-${finalAttrs.version}.tar.xz";
    hash = "sha256-Y23pFov1/WKPrwYYRfGI8sOF0tp/ksSwRJE5zmxtoSo=";
  };

  # fix concatenation of absolute paths like
  # /nix/store/77zcv3vmndif01d4wh1rh0d1dyvyqzpy-gcompris-25.1.1/bin/..//nix/store/77zcv3vmndif01d4wh1rh0d1dyvyqzpy-gcompris-25.1.1/share/gcompris-qt/rcc/core.rcc
  postPatch = ''
    substituteInPlace src/core/config.h.in  --replace-fail \
      "../@_data_dest_dir@" "../share/gcompris-qt"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "QML_BOX2D_LIBRARY" "${kdePackages.qmlbox2d}/${kdePackages.qtbase.qtQmlPrefix}/Box2D.2.1")
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    gettext
    ninja
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs =
    with kdePackages;
    [
      qmlbox2d
      qtbase
      qtcharts
      qtdeclarative
      qtimageformats
      qtmultimedia
      qtsensors
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
    ]);

  postInstall = ''
    install -Dm444 ../org.kde.gcompris.appdata.xml -t $out/share/metainfo

    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  # we need a graphical environment for the tests
  doCheck = false;

  meta = {
    description = "High quality educational software suite, including a large number of activities for children aged 2 to 10";
    homepage = "https://gcompris.net/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gcompris-qt";
    maintainers = with lib.maintainers; [ guibou ];
    platforms = lib.platforms.linux;
  };
})
