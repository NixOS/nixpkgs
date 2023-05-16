<<<<<<< HEAD
{ channel
, version
, hash
=======
{ stable
, branch
, version
, sha256Hash
, mkOverride
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

{ lib
, python3
, fetchFromGitHub
, wrapQtAppsHook
}:

<<<<<<< HEAD
python3.pkgs.buildPythonApplication rec {
=======
python3.pkgs.buildPythonPackage rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "gns3-gui";
  inherit version;

  src = fetchFromGitHub {
<<<<<<< HEAD
    inherit hash;
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
  };

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
=======
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jsonschema
    psutil
    sentry-sdk
    setuptools
    sip_4 (pyqt5.override { withWebSockets = true; })
<<<<<<< HEAD
    truststore
  ];

  pythonRelaxDeps = [
    "jsonschema"
    "sentry-sdk"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = false; # Failing

  dontWrapQtApps = true;

<<<<<<< HEAD
  preFixup = ''
    wrapQtApp "$out/bin/gns3"
  '';

  meta = with lib; {
    description = "Graphical Network Simulator 3 GUI (${channel} release)";
=======
  postFixup = ''
      wrapQtApp "$out/bin/gns3"
  '';

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "psutil==" "psutil>=" \
      --replace "jsonschema>=4.17.0,<4.18" "jsonschema" \
      --replace "sentry-sdk==1.10.1,<1.11" "sentry-sdk"
  '';

  meta = with lib; {
    description = "Graphical Network Simulator 3 GUI (${branch} release)";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "gns3";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
