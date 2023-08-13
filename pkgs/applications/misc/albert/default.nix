{ lib
, stdenv
, fetchFromGitHub
, cmake
, libqalculate
, muparser
, python3Packages
, qtbase
, qtscxml
, qtsvg
, wrapQtAppsHook
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "albert";
  version = "0.20.14";

  src = fetchFromGitHub {
    owner = "albertlauncher";
    repo = "albert";
    rev = "v${version}";
    sha256 = "sha256-c1Bp7rIloXuWv/kUzWGJJ+bh9656vpuqADy77zYZjqk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    libqalculate
    muparser
    qtbase
    qtscxml
    qtsvg
  ] ++ (with python3Packages; [ python pybind11 ]);

  postPatch = ''
    find -type f -name CMakeLists.txt -exec sed -i {} -e '/INSTALL_RPATH/d' \;

    sed -i src/nativepluginprovider.cpp \
      -e "/QStringList dirs = {/a    QFileInfo(\"$out/lib\").canonicalFilePath(),"
  '';

  postFixup = ''
    for i in $out/{bin/.albert-wrapped,lib/albert/plugins/*.so}; do
      patchelf $i --add-rpath $out/lib/albert
    done
  '';

  passthru.updateScript = nix-update-script { };

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
