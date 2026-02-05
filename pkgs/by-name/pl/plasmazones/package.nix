{
  lib,
  stdenv,
  cmake,
  kdePackages,
  qt6,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasmazones";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "fuddlesworth";
    repo = "PlasmaZones";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fqs11tv8ejRBszWKhNHo1lozI00lsk7aNdOBwqxCG5Y=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
  ]
  ++ (with kdePackages; [
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    ki18n
    kcmutils
    kwindowsystem
    kglobalaccel
    knotifications
    kcolorscheme
    layer-shell-qt
    kwin
  ]);

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  postInstall = ''
    substituteInPlace $out/share/systemd/user/plasmazones.service \
      --replace-fail "/usr/bin/plasmazonesd" "$out/bin/plasmazonesd"
  '';

  meta = {
    description = "FancyZones-style window tiling for KDE Plasma";
    homepage = "https://github.com/fuddlesworth/PlasmaZones";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pacjo ];
    platforms = lib.platforms.linux;
  };
})
