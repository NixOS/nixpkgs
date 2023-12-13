{ lib, buildPythonApplication, fetchFromGitHub, python3Packages }:

buildPythonApplication rec {
  pname = "codexctl";
  version = "1701639955";
  format = "other";

  src = fetchFromGitHub {
    owner = "jayy001";
    repo = pname;
    rev = version;
    hash = "sha256-7+4gNISI2TBcoyX+2Xj9Ch4NopAnFNNUh2zhp8jiBYQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/codexctl
    cp codexctl.py $out/share/codexctl
    cp -r modules/ $out/share/codexctl

    makeWrapper ${python3Packages.python.interpreter} $out/bin/codexctl \
      --set PYTHONPATH "$PYTHONPATH" \
      --add-flags "-O $out/share/codexctl/codexctl.py"

    runHook postInstall
  '';

  propagatedBuildInputs = with python3Packages; [ paramiko psutil requests loguru protobuf six ];

  meta = with lib; {
    description = "A tool to modify remarkable device versions";
    homepage = "https://github.com/jayy001/codexctl";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
