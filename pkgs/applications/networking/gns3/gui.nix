{ stable
, branch
, version
, sha256Hash
, mkOverride
}:

{ lib
, python3
, fetchFromGitHub
, wrapQtAppsHook
}:

python3.pkgs.buildPythonPackage rec {
  pname = "gns3-gui";
  inherit version;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jsonschema
    psutil
    sentry-sdk
    setuptools
    sip_4 (pyqt5.override { withWebSockets = true; })
  ];

  doCheck = false; # Failing

  dontWrapQtApps = true;

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
  };
}
