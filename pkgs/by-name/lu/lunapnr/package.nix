{ lib
, fetchFromGitHub
, fetchFromBitbucket
, gcc11Stdenv

  # dependencies
, boost
, cmake
, eigen
, ninja
, opensta
, python3
, qt5
}:

let
  version = "0.1.6";

  tinysvgpp = fetchFromBitbucket {
    owner = "trcwm";
    repo = "tinysvgpp";
    rev = "2589ed";
    hash = "sha256-VmD1NJUPUET1LMHn6IPTLaSJ0HEk/Q158xT0+3R9LFc=";
  };
in
gcc11Stdenv.mkDerivation {
  pname = "lunapnr";
  inherit version;

  src = fetchFromGitHub {
    owner = "asicsforthemasses";
    repo = "LunaPnR";
    rev = "v${version}";
    hash = "sha256-Xyt+isrMmy3MaN3cv1gsx3tOM30KLnbcaWJYgKhwjRU=";
  };

  patchPhase = ''
    cp -r ${tinysvgpp}/* contrib/tinysvgpp
    substituteInPlace contrib/CMakeLists.txt \
      --replace-fail 'find_package(Git REQUIRED)' ''' \
      --replace-fail 'if(NOT EXISTS tinysvgpp/CMakeLists.txt)' 'if(FALSE)'

    substituteInPlace CMakeLists.txt \
      --replace-fail 'enable_testing()' ''' \
      --replace-fail 'add_subdirectory(test)' ''' \
      --replace-fail 'DESTINATION ''${LUNA_INSTALL_PREFIX}/bin)' "DESTINATION $out/bin)"

    substituteInPlace gui/src/mainwindow.cpp \
      --replace-fail 'settings.value("opensta_location", "/usr/local/bin/sta").toString()' 'QString("${opensta}/bin/sta")'
  '';

  buildInputs = [ qt5.qtbase qt5.qttools eigen boost ];
  propagatedBuildInputs = [ python3 ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook cmake ninja ];

  # broken as tools/doctool is used before it is being built
  enableParallelBuilding = false;

  meta = {
    description = "A robust place and route tool intended for IC processes with features sizes greater than 100nm";
    homepage = "https://www.asicsforthemasses.com";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
