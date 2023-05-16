{ lib
, stdenv
, fetchFromGitHub
, cmake
<<<<<<< HEAD
, libqalculate
, muparser
, libarchive
, python3Packages
, qtbase
, qtscxml
, qtsvg
, qtdeclarative
, qt5compat
=======
, muparser
, python3
, qtbase
, qtcharts
, qtdeclarative
, qtgraphicaleffects
, qtsvg
, qtx11extras
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wrapQtAppsHook
, nix-update-script
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "albert";
  version = "0.22.0";
=======
stdenv.mkDerivation rec {
  pname = "albert";
  version = "0.17.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "albertlauncher";
    repo = "albert";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-x5H7z0rwunfMwtihXEerc47Sdkl6IvSHfavXzXMLse0=";
=======
    rev = "v${version}";
    sha256 = "sha256-nbnywrsKvFG8AkayjnylOKSnn7rRWgNv5zE9DDeOmLw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
<<<<<<< HEAD
    libqalculate
    libarchive
    muparser
    qtbase
    qtscxml
    qtsvg
    qtdeclarative
    qt5compat
  ] ++ (with python3Packages; [ python pybind11 ]);
=======
    muparser
    python3
    qtbase
    qtcharts
    qtdeclarative
    qtgraphicaleffects
    qtsvg
    qtx11extras
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    find -type f -name CMakeLists.txt -exec sed -i {} -e '/INSTALL_RPATH/d' \;

<<<<<<< HEAD
    sed -i src/qtpluginprovider.cpp \
=======
    sed -i src/app/main.cpp \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      -e "/QStringList dirs = {/a    QFileInfo(\"$out/lib\").canonicalFilePath(),"
  '';

  postFixup = ''
    for i in $out/{bin/.albert-wrapped,lib/albert/plugins/*.so}; do
      patchelf $i --add-rpath $out/lib/albert
    done
  '';

<<<<<<< HEAD
  passthru = {
    updateScript = nix-update-script { };
  };
=======
  passthru.updateScript = nix-update-script { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A fast and flexible keyboard launcher";
    longDescription = ''
      Albert is a desktop agnostic launcher. Its goals are usability and beauty,
      performance and extensibility. It is written in C++ and based on the Qt
      framework.
    '';
    homepage = "https://albertlauncher.github.io";
<<<<<<< HEAD
    changelog = "https://github.com/albertlauncher/albert/blob/${finalAttrs.src.rev}/CHANGELOG.md";
=======
    changelog = "https://github.com/albertlauncher/albert/blob/${src.rev}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes synthetica ];
    platforms = platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
