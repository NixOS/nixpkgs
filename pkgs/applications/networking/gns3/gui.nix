{ stable, branch, version, sha256Hash, mkOverride, commonOverrides }:

{ lib, python3, fetchFromGitHub, wrapQtAppsHook }:

let
  defaultOverrides = commonOverrides ++ [
  ];

  python = python3.override {
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) defaultOverrides;
  };
in python.pkgs.buildPythonPackage rec {
  pname = "gns3-gui";
  inherit version;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  nativeBuildInputs = [ wrapQtAppsHook ];
  propagatedBuildInputs = with python.pkgs; [
    sentry-sdk psutil jsonschema # tox for check
    # Runtime dependencies
    sip_4 (pyqt5.override { withWebSockets = true; }) distro setuptools
  ];

  doCheck = false; # Failing
  dontWrapQtApps = true;
  postFixup = ''
      wrapQtApp "$out/bin/gns3"
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
    maintainers = with maintainers; [ ];
  };
}
