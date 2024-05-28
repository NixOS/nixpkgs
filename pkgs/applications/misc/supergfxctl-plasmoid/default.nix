{ lib
, stdenv
, fetchFromGitLab
, cmake
, gcc
, hicolor-icon-theme
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "supergfxctl-plasmoid";
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "jhyub";
    repo = pname;
    rev = "v2.0.0";
    sha256 = "1c9s3mab6p8bbanc1b5ypb5rjl5n9ma32814ra1amdpxa1n6cwwv";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    gcc
  ];

  buildInputs = [
    hicolor-icon-theme
    kdePackages.wrapQtAppsHook
    kdePackages.kcoreaddons
    kdePackages.kconfig
    kdePackages.ki18n
    kdePackages.kirigami
    kdePackages.ksvg
    kdePackages.libplasma
    kdePackages.full
    kdePackages.frameworkintegration
  ];

  buildPhase = ''
    cmake -DBUILD_WITH_QT6=ON ..
    make
  '';

  meta = with lib; {
    description = "KDE Plasma plasmoid for supergfxctl";
    longDescription = ''
      KDE Plasma plasmoid for supergfxctl
      Built as a C++/QML Plasmoid
    '';
    license = licenses.mpl20;
    homepage = "https://gitlab.com/Jhyub/supergfxctl-plasmoid";
    maintainers = with maintainers; [ johnylpm ];
  };
}
