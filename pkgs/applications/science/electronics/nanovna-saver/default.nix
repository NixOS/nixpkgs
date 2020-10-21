{ lib, mkDerivationWith, wrapQtAppsHook, python3Packages, fetchFromGitHub
, qtbase }:

let
  version = "0.3.7";
  pname = "nanovna-saver";

in mkDerivationWith python3Packages.buildPythonApplication {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "NanoVNA-Saver";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c22ckyypg91gfb2sdc684msw28nnb6r8cq3b362gafvv00a35mi";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    cython
    scipy_1_4
    pyqt5
    pyserial
    numpy
  ];

  doCheck = false;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postFixup = ''
    wrapProgram $out/bin/NanoVNASaver \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/NanoVNA-Saver/nanovna-saver";
    description =
      "A tool for reading, displaying and saving data from the NanoVNA";
    longDescription = ''
      A multiplatform tool to save Touchstone files from the NanoVNA, sweep
      frequency spans in segments to gain more than 101 data points, and
      generally display and analyze the resulting data.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zaninime ];
  };
}
