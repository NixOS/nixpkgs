{ lib
, stdenv
, fetchFromGitLab
, cmake
<<<<<<< HEAD
<<<<<<< HEAD
=======
, gcc
, hicolor-icon-theme
>>>>>>> 83a2e102fc2b (move package to appropriate location)
=======
>>>>>>> a590fd9cfbad (shave off unnecessary portions and implemented better practices)
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "supergfxctl-plasmoid";
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "jhyub";
<<<<<<< HEAD
<<<<<<< HEAD
    repo = "supergfxctl-plasmoid";
    rev = "refs/tags/v${version}";
    hash = "sha256-m3NmbFD9tqqCyiQgMVRNtlCZy7q+rMCsWgtds1QdOrE=";
=======
    repo = pname;
    rev = "v2.0.0";
    sha256 = "1c9s3mab6p8bbanc1b5ypb5rjl5n9ma32814ra1amdpxa1n6cwwv";
>>>>>>> 83a2e102fc2b (move package to appropriate location)
=======
    repo = "supergfxctl-plasmoid";
    rev = "refs/tags/v${version}";
    hash = "sha256-m3NmbFD9tqqCyiQgMVRNtlCZy7q+rMCsWgtds1QdOrE=";
>>>>>>> a590fd9cfbad (shave off unnecessary portions and implemented better practices)
  };

  nativeBuildInputs = [
    cmake
<<<<<<< HEAD
<<<<<<< HEAD
  ];

  buildInputs = [
    kdePackages.wrapQtAppsHook
    kdePackages.libplasma
  ];

  meta = {
=======
    kdePackages.extra-cmake-modules
    gcc
=======
>>>>>>> a590fd9cfbad (shave off unnecessary portions and implemented better practices)
  ];

  buildInputs = [
    kdePackages.wrapQtAppsHook
    kdePackages.libplasma
  ];

<<<<<<< HEAD
  buildPhase = ''
    cmake -DBUILD_WITH_QT6=ON ..
    make
  '';

  meta = with lib; {
>>>>>>> 83a2e102fc2b (move package to appropriate location)
=======
  meta = {
>>>>>>> a590fd9cfbad (shave off unnecessary portions and implemented better practices)
    description = "KDE Plasma plasmoid for supergfxctl";
    longDescription = ''
      KDE Plasma plasmoid for supergfxctl
      Built as a C++/QML Plasmoid
    '';
<<<<<<< HEAD
<<<<<<< HEAD
    license = lib.licenses.mpl20;
    homepage = "https://gitlab.com/Jhyub/supergfxctl-plasmoid";
    maintainers = with lib.maintainers; [ johnylpm ];
=======
    license = licenses.mpl20;
    homepage = "https://gitlab.com/Jhyub/supergfxctl-plasmoid";
    maintainers = with maintainers; [ johnylpm ];
>>>>>>> 83a2e102fc2b (move package to appropriate location)
=======
    license = lib.licenses.mpl20;
    homepage = "https://gitlab.com/Jhyub/supergfxctl-plasmoid";
    maintainers = with lib.maintainers; [ johnylpm ];
>>>>>>> a590fd9cfbad (shave off unnecessary portions and implemented better practices)
  };
}
