{
  lib,
  stdenv,
  fetchFromGitLab,
  extra-cmake-modules,
  shared-mime-info,
  wrapQtAppsHook,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kio,
  solid,
  kidletime,
  knotifications,
  kconfig,
  kinit,
  kjobwidgets,
  kcmutils,
  plasma-framework,
  libgit2,
}:

stdenv.mkDerivation rec {
  pname = "kup";
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "kup";
    owner = "system";
    rev = "kup-${version}";
    hash = "sha256-G/GXmcQI1OBnCE7saPHeHDAMeL2WR6nVttMlKV2e01I=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
    wrapQtAppsHook
  ];

  buildInputs = [
    kcoreaddons
    kdbusaddons
    ki18n
    kio
    solid
    kidletime
    knotifications
    kconfig
    kinit
    kjobwidgets
    plasma-framework
    libgit2
    kcmutils
  ];

  meta = with lib; {
    description = "Backup tool for KDE";
    homepage = "https://apps.kde.org/kup";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pwoelfel ];
  };
}
