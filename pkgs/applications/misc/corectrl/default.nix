{ lib, stdenv
, fetchFromGitLab
, extra-cmake-modules
, botan2
, karchive
, kauth
, libdrm
, hwdata
, mesa-demos
, procps
, util-linux
, vulkan-tools
, qtbase
, qtcharts
, qtquickcontrols2
, qtsvg
, qttools
, qtxmlpatterns
, wrapQtAppsHook
} :

stdenv.mkDerivation rec{
  pname = "corectrl";
  version = "1.1.4";

  src = fetchFromGitLab {
    owner = "corectrl";
    repo = "corectrl";
    rev = "v${version}";
    sha256 = "sha256-o8u9WnkK/6VZ+wlJ9I5Ti6ADjV9VXraRGpSWkDQv5JQ=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    wrapQtAppsHook
  ];
  buildInputs = [
    botan2
    karchive
    kauth
    libdrm
    mesa-demos
    procps
    util-linux
    vulkan-tools
    qtbase
    qtcharts
    qtquickcontrols2
    qtsvg
    qttools
    qtxmlpatterns
  ];

  cmakeFlags = [ "-DWITH_PCI_IDS_PATH=${hwdata}/share/hwdata/pci.ids" ];

  runtimeDeps = [ hwdata mesa-demos vulkan-tools ];
  binPath = lib.makeBinPath runtimeDeps;

  dontWrapQtApps = true;

  postInstall = ''
    wrapQtApp $out/bin/corectrl --prefix PATH ":" ${binPath}
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/corectrl/corectrl/";
    description = "Control your computer hardware via application profiles";
    longDescription = ''
      CoreCtrl is a Free and Open Source GNU/Linux application that allows you
      to control with ease your computer hardware using application profiles. It
      aims to be flexible, comfortable and accessible to regular users.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
# TODO: report upstream that libdrm is not detected at configure time
