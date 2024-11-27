{ lib
, aircrack-ng
, fetchFromGitHub
, iproute2
, networkmanager
, python3
, tshark
, wirelesstools
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dbmonster";
  version = "unstable-2022-09-17";
  format = "other";

  src = fetchFromGitHub {
    owner = "90N45-d3v";
    repo = "dBmonster";
    rev = "4c79549079782a2991309120a55c8158701a9b70";
    hash = "sha256-9RP3LmZF7P2c0+Jt/kMSVPb4cBtyH6P3FZ5UrQpBP0I=";
  };

  propagatedBuildInputs = [
    aircrack-ng
    iproute2
    networkmanager
    tshark
    wirelesstools
  ] ++ (with python3.pkgs; [
    matplotlib
  ]);

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -vD dBmonster.py $out/bin/$pname.py

    makeWrapper ${python3.interpreter} $out/bin/$pname \
      --set PYTHONPATH "$PYTHONPATH:$out/bin/$pname" \
      --add-flags "-O $out/bin/$pname.py"

    runHook postInstall
  '';

  # Only script available
  doCheck = false;

  meta = with lib; {
    description = "Tool to track WiFi devices by signal strength";
    homepage = "https://github.com/90N45-d3v/dBmonster";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
