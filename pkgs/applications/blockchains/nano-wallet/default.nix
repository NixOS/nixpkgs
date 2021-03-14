{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook, boost, libGL
, qtbase}:

stdenv.mkDerivation rec {

  pname = "nano-wallet";
  version = "20.0";

  src = fetchFromGitHub {
    owner = "nanocurrency";
    repo = "raiblocks";
    rev = "V${version}";
    sha256 = "12nrjjd89yjzx20d85ccmp395pl0djpx0x0qb8dgka8xfy11k7xn";
    fetchSubmodules = true;
  };

  # Use a patch to force dynamic linking
  patches = [
    ./CMakeLists.txt.patch
  ];

  cmakeFlags = let
    options = {
      BOOST_ROOT = boost;
      Boost_USE_STATIC_LIBS = "OFF";
      RAIBLOCKS_GUI = "ON";
      RAIBLOCKS_TEST = "ON";
      Qt5_DIR = "${qtbase.dev}/lib/cmake/Qt5";
      Qt5Core_DIR = "${qtbase.dev}/lib/cmake/Qt5Core";
      Qt5Gui_INCLUDE_DIRS = "${qtbase.dev}/include/QtGui";
      Qt5Widgets_INCLUDE_DIRS = "${qtbase.dev}/include/QtWidgets";
    };
    optionToFlag = name: value: "-D${name}=${value}";
  in lib.mapAttrsToList optionToFlag options;

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ boost libGL qtbase ];

  buildPhase = ''
    make nano_wallet
  '';

  # Move executables under bin directory
  postInstall = ''
    mkdir -p $out/bin
    mv $out/nano* $out/bin/
  '';

  checkPhase = ''
    ./core_test
  '';

  meta = {
    inherit version;
    description = "Wallet for Nano cryptocurrency";
    homepage = "https://nano.org/en/wallet/";
    license = lib.licenses.bsd2;
    # Fails on Darwin. See:
    # https://github.com/NixOS/nixpkgs/pull/39295#issuecomment-386800962
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jluttine ];
  };

}
