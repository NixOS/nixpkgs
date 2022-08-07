{ lib
, stdenv
, fetchFromGitHub
, cmake
, muparser
, python3
, qtbase
, qtcharts
, qtdeclarative
, qtgraphicaleffects
, qtsvg
, qtx11extras
, wrapQtAppsHook
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "albert";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "albertlauncher";
    repo = "albert";
    rev = "v${version}";
    sha256 = "sha256-UIG6yLkIcdf5IszhNPwkBcSfZe4/CyI5shK/QPOmpPE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    muparser
    python3
    qtbase
    qtcharts
    qtdeclarative
    qtgraphicaleffects
    qtsvg
    qtx11extras
  ];

  postPatch = ''
    find -type f -name CMakeLists.txt -exec sed -i {} -e '/INSTALL_RPATH/d' \;

    sed -i src/app/main.cpp \
      -e "/QStringList dirs = {/a    QFileInfo(\"$out/lib\").canonicalFilePath(),"
  '';

  postFixup = ''
    for i in $out/{bin/.albert-wrapped,lib/albert/plugins/*.so}; do
      patchelf $i --add-rpath $out/lib/albert
    done
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "A fast and flexible keyboard launcher";
    longDescription = ''
      Albert is a desktop agnostic launcher. Its goals are usability and beauty,
      performance and extensibility. It is written in C++ and based on the Qt
      framework.
    '';
    homepage = "https://albertlauncher.github.io";
    changelog = "https://github.com/albertlauncher/albert/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes synthetica ];
    platforms = platforms.linux;
  };
}
