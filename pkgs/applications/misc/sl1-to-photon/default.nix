{ lib
, buildPythonApplication
, fetchFromGitHub
, pillow
, pyside2
, numpy
, pyphotonfile
, shiboken2
}:
let
  version = "0.1.3";
in
 buildPythonApplication rec {
  pname = "sl1-to-photon";
  inherit version;

  src = fetchFromGitHub {
    owner = "fookatchu";
    repo = "SL1toPhoton";
    rev = "v${version}";
    sha256 = "1hmb74rcky3nax4lxn7pw6lcd5a66fdbwrm11c84zb31xb51bakw";
  };

  propagatedBuildInputs = [ pyphotonfile pillow numpy pyside2 shiboken2 ];

  format = "other";

  installPhase = ''
    install -D -m 0755 SL1_to_Photon.py $out/bin/${pname}
    sed -i '1i#!/usr/bin/env python' $out/bin/${pname}
  '';

  meta = with lib; {
    maintainers = [ maintainers.cab404 ];
    license = licenses.gpl3Plus;
    description = "Tool for converting Slic3r PE's SL1 files to Photon files for the Anycubic Photon 3D-Printer";
    homepage = "https://github.com/fookatchu/SL1toPhoton";
  };

}
