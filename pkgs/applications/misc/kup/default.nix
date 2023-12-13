{ lib,
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
  plasma-framework,
  libgit2
}:

stdenv.mkDerivation rec {
  pname = "kup";
  version = "0.9.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = pname;
    owner = "system";
    rev = "${pname}-${version}";
    sha256 = "1s180y6vzkxxcjpfdvrm90251rkaf3swzkjwdlpm6m4vnggq0hvs";
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
  ];

  meta = with lib; {
    description = "Backup tool for KDE";
    homepage = "https://apps.kde.org/kup";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pwoelfel ];
  };
}
