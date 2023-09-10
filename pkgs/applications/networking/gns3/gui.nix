{ channel
, version
, hash
}:

{ lib
, python3
, fetchFromGitHub
, wrapQtAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gns3-gui";
  inherit version;

  src = fetchFromGitHub {
    inherit hash;
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
  };

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jsonschema
    psutil
    sentry-sdk
    setuptools
    sip_4 (pyqt5.override { withWebSockets = true; })
    truststore
  ];

  pythonRelaxDeps = [
    "jsonschema"
    "sentry-sdk"
  ];

  doCheck = false; # Failing

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/gns3"
  '';

  meta = with lib; {
    description = "Graphical Network Simulator 3 GUI (${channel} release)";
    longDescription = ''
      Graphical user interface for controlling the GNS3 network simulator. This
      requires access to a local or remote GNS3 server (it's recommended to
      download the official GNS3 VM).
    '';
    homepage = "https://www.gns3.com/";
    changelog = "https://github.com/GNS3/gns3-gui/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ anthonyroussel ];
    mainProgram = "gns3";
  };
}
