{ lib
, stdenv
, fetchFromGitHub
, cmake
, libqalculate
, muparser
, libarchive
, python3Packages
, qtbase
, qtscxml
, qtsvg
, qtdeclarative
, qt5compat
, wrapQtAppsHook
, nix-update-script
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "albert";
  version = "0.22.9";

  src = fetchFromGitHub {
    owner = "albertlauncher";
    repo = "albert";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-MhZHklb//VH2GkAzK46P7EwCIa50l5y+2VssrgpTlWA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libqalculate
    libarchive
    muparser
    qtbase
    qtscxml
    qtsvg
    qtdeclarative
    qt5compat
  ] ++ (with python3Packages; [ python pybind11 ]);

  postPatch = ''
    find -type f -name CMakeLists.txt -exec sed -i {} -e '/INSTALL_RPATH/d' \;

    sed -i src/qtpluginprovider.cpp \
      -e "/QStringList dirs = {/a    QFileInfo(\"$out/lib\").canonicalFilePath(),"
  '';

  postFixup = ''
    for i in $out/{bin/.albert-wrapped,lib/albert/plugins/*.so}; do
      patchelf $i --add-rpath $out/lib/albert
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A fast and flexible keyboard launcher";
    longDescription = ''
      Albert is a desktop agnostic launcher. Its goals are usability and beauty,
      performance and extensibility. It is written in C++ and based on the Qt
      framework.
    '';
    homepage = "https://albertlauncher.github.io";
    changelog = "https://github.com/albertlauncher/albert/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes synthetica ];
    mainProgram = "albert";
    platforms = platforms.linux;
  };
})
