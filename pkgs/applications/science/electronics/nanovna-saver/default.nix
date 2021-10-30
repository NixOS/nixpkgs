{ lib
, python3
, fetchFromGitHub
, wrapQtAppsHook
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      scipy = super.scipy.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0ndw7zyxd2dj37775mc75zm4fcyiipnqxclc45mkpxy8lvrvpqfy";
        };
        doCheck = false;
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "nanovna-saver";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "NanoVNA-Saver";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z83rwpnbbs1n74mx8dgh1d1crp90mannj9vfy161dmy4wzc5kpv";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python.pkgs; [
    cython
    scipy
    pyqt5
    pyserial
    numpy
  ];

  doCheck = false;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "''${qtWrapperArgs[@]}"
    )
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
