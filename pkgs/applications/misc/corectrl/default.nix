{ lib, stdenv
, fetchFromGitLab
, extra-cmake-modules
, botan2
, karchive
, kauth
, libdrm
, hwdata
, glxinfo
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
  version = "1.2.4";

  src = fetchFromGitLab {
    owner = "corectrl";
    repo = "corectrl";
    rev = "v${version}";
    sha256 = "sha256-3WOuPOJEY941JVoF5aQp5LvPeh3shalb6H9FMmmctN4=";
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
    glxinfo
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

  runtimeDeps = [ hwdata glxinfo vulkan-tools util-linux procps ];
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
