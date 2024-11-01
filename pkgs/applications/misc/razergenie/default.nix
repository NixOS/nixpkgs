{ stdenv, fetchFromGitHub, lib, meson, ninja, pkg-config, qtbase, qttools
, wrapQtAppsHook
, enableExperimental ? false
, includeMatrixDiscovery ? false
}:

let
  version = "0.9.0";
  pname = "razergenie";

in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "z3ntu";
    repo = "RazerGenie";
    rev = "v${version}";
    sha256 = "17xlv26q8sdbav00wdm043449pg2424l3yaf8fvkc9rrlqkv13a4";
  };

  nativeBuildInputs = [
    pkg-config meson ninja wrapQtAppsHook
  ];

  buildInputs = [
    qtbase qttools
  ];

  mesonFlags = [
    "-Denable_experimental=${lib.boolToString enableExperimental}"
    "-Dinclude_matrix_discovery=${lib.boolToString includeMatrixDiscovery}"
  ];

  meta = with lib; {
    homepage = "https://github.com/z3ntu/RazerGenie";
    description = "Qt application for configuring your Razer devices under GNU/Linux";
    mainProgram = "razergenie";
    license = licenses.gpl3;
    maintainers = with maintainers; [ f4814n Mogria ];
    platforms = platforms.linux;
  };
}
