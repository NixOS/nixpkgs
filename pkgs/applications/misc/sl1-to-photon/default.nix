{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pillow,
  pyside2,
  numpy,
  pyphotonfile,
  shiboken2,
}:
let
  version = "0.1.3+";
in
buildPythonApplication rec {
  pname = "sl1-to-photon";
  inherit version;

  src = fetchFromGitHub {
    owner = "cab404";
    repo = "SL1toPhoton";
    rev = "7edc6ea99818622f5d49ac7af80ddd4916b8c19f";
    sha256 = "ssFfjlBMi3FHosDBUA2gs71VUIBkEdPVcV3STNxmOIM=";
  };

  pythonPath = [
    pyphotonfile
    pillow
    numpy
    pyside2
    shiboken2
  ];

  format = "setuptools";
  dontUseSetuptoolsCheck = true;

  installPhase = ''
    install -D -m 0755 SL1_to_Photon.py $out/bin/${pname}
  '';

  meta = with lib; {
    maintainers = [ maintainers.cab404 ];
    license = licenses.gpl3Plus;
    description = "Tool for converting Slic3r PE's SL1 files to Photon files for the Anycubic Photon 3D-Printer";
    homepage = "https://github.com/cab404/SL1toPhoton";
    mainProgram = "sl1-to-photon";
  };

}
