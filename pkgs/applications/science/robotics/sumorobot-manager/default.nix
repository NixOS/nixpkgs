{
  lib,
  stdenv,
  python3Packages,
  qt5,
  fetchFromGitHub,
  dos2unix,
}:

stdenv.mkDerivation rec {
  pname = "sumorobot-manager";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "robokoding";
    repo = pname;
    rev = "v${version}";
    sha256 = "07snhwmqqp52vdgr66vx50zxx0nmpmns5cdjgh50hzlhji2z1fl9";
  };

  buildInputs = [ python3Packages.python ];

  pythonPath = with python3Packages; [
    pyqt5.dev
    pyserial
  ];

  nativeBuildInputs = [
    python3Packages.wrapPython
    qt5.wrapQtAppsHook
    dos2unix
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/opt/sumorobot-manager
    cp -r main.py lib res $out/opt/sumorobot-manager
    chmod -R 644 $out/opt/sumorobot-manager/lib/*
    mkdir $out/bin
    dos2unix $out/opt/sumorobot-manager/main.py
    makeQtWrapper $out/opt/sumorobot-manager/main.py $out/bin/sumorobot-manager \
      --chdir "$out/opt/sumorobot-manager"
  '';

  preFixup = ''
    patchShebangs $out/opt/sumorobot-manager/main.py
    wrapPythonProgramsIn "$out/opt" "$pythonPath"
  '';

  meta = with lib; {
    description = "Desktop App for managing SumoRobots";
    mainProgram = "sumorobot-manager";
    homepage = "https://www.robokoding.com/kits/sumorobot/sumomanager/";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
