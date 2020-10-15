{ stdenv
, fetchFromGitLab
, extra-cmake-modules
, botan2
, karchive
, kauth
, libdrm
, mesa-demos
, procps
, utillinux
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
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "corectrl";
    repo = "corectrl";
    rev = "v${version}";
    sha256 = "sha256-YQDrxPqCa3OzNKd3UiAffqqvOrgbXmDFJGjYPetolyY=";
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
    utillinux
    vulkan-tools
    qtbase
    qtcharts
    qtquickcontrols2
    qtsvg
    qttools
    qtxmlpatterns
  ];

  runtimeDeps = [ mesa-demos vulkan-tools ];
  binPath = stdenv.lib.makeBinPath runtimeDeps;

  dontWrapQtApps = true;

  postInstall = ''
    wrapQtApp $out/bin/corectrl --prefix PATH ":" ${binPath}
  '';

  meta = with stdenv.lib; {
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
