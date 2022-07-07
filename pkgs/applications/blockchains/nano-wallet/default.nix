{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook, boost, libGL
, qtbase, python3 }:

stdenv.mkDerivation rec {

  pname = "nano-wallet";
  version = "21.3";

  src = fetchFromGitHub {
    owner = "nanocurrency";
    repo = "nano-node";
    rev = "V${version}";
    sha256 = "0f6chl5vrzdr4w8g3nivfxk3qm6m11js401998afnhz0xaysm4pm";
    fetchSubmodules = true;
  };

  cmakeFlags = let
    options = {
      PYTHON_EXECUTABLE = "${python3.interpreter}";
      NANO_SHARED_BOOST = "ON";
      BOOST_ROOT = boost;
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

  strictDeps = true;

  buildPhase = ''
    runHook preBuild
    make nano_wallet
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    ./core_test
    runHook postCheck
  '';

  meta = {
    description = "Wallet for Nano cryptocurrency";
    homepage = "https://nano.org/en/wallet/";
    license = lib.licenses.bsd2;
    # Fails on Darwin. See:
    # https://github.com/NixOS/nixpkgs/pull/39295#issuecomment-386800962
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jluttine ];
  };

}
