{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  boost,
  libGL,
  qtbase,
  python3,
}:

stdenv.mkDerivation rec {

  pname = "nano-wallet";
  version = "28.2";

  src = fetchFromGitHub {
    owner = "nanocurrency";
    repo = "nano-node";
    tag = "V${version}";
    fetchSubmodules = true;
    hash = "sha256-Wo1Gd6dOnCoPiGmuJQhZmKKSg7LrKpfdvLNNKBYTUWI=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  patches = [
    # fix issue with <algorithm> include
    (fetchpatch {
      url = "https://github.com/nanocurrency/nano-node/commit/1835a04dbbd1f6970649d7f72c454831432dd01f.patch";
      hash = "sha256-IpC4yaIbJzQWYIC0QGXYQ345g6JnD2+xZG30qAQ1ubo=";
    })
  ];

  cmakeFlags =
    let
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
    in
    lib.mapAttrsToList optionToFlag options;

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    boost
    libGL
    qtbase
  ];

  strictDeps = true;

  makeFlags = [ "nano_wallet" ];

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
