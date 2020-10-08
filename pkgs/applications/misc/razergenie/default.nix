{ stdenv, fetchFromGitHub, lib, meson, ninja, pkgconfig, qtbase, qttools
, wrapQtAppsHook
, enableExperimental ? false
, includeMatrixDiscovery ? false
}:

let
  version = "0.8.1";
  pname = "razergenie";

in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "z3ntu";
    repo = "RazerGenie";
    rev = "v${version}";
    sha256 = "1ggxnaidxbbpkv1h3zwwyci6886sssgslk5adbikbhz9kc9qg239";
  };

  nativeBuildInputs = [
    pkgconfig meson ninja wrapQtAppsHook
  ];

  buildInputs = [
    qtbase qttools
  ];

  mesonFlags = [
    "-Denable_experimental=${if enableExperimental then "true" else "false"}"
    "-Dinclude_matrix_discovery=${if includeMatrixDiscovery then "true" else "false"}"
  ];

  meta = with lib; {
    homepage = "https://github.com/z3ntu/RazerGenie";
    description = "Qt application for configuring your Razer devices under GNU/Linux";
    license = licenses.gpl3;
    maintainers = with maintainers; [ f4814n ];
    platforms = platforms.linux;
  };
}
