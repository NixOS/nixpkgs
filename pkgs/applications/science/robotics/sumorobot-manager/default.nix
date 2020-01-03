{ stdenv, python3, qt5, fetchFromGitHub, wrapPython, pyqt5, pyserial }:
 
stdenv.mkDerivation rec {
  pname = "sumorobot-manager";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "robokoding";
    repo = pname;
    rev = "v${version}";
    sha256 = "03zhb54c259a66hsahmv2ajbzwcjnfjj050wbjhw51zqzxinlgqr";
  };

  buildInputs = [ python3 ];
  pythonPath = [
    pyqt5 pyserial
  ];

  nativeBuildInputs = [ wrapPython qt5.wrapQtAppsHook ];

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/opt/sumorobot-manager
    cp -r main.py lib res $out/opt/sumorobot-manager
    chmod -R 644 $out/opt/sumorobot-manager/lib/*
    mkdir $out/bin
    makeQtWrapper $out/opt/sumorobot-manager/main.py $out/bin/sumorobot-manager \
      --run "cd $out/opt/sumorobot-manager"
  '';

  preFixup = ''
    patchShebangs $out/opt/sumorobot-manager/main.py
    wrapPythonProgramsIn "$out/opt" "$pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "Desktop App for managing SumoRobots";
    homepage = "https://www.robokoding.com/kits/sumorobot/sumomanager/";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
