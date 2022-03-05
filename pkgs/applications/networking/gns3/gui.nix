{ stable, branch, version, sha256Hash, mkOverride, commonOverrides }:

{ lib, python3, fetchFromGitHub, wrapQtAppsHook }:

let
  defaultOverrides = commonOverrides ++ [
  ];

  python = python3.override {
    packageOverrides = lib.foldr lib.composeExtensions (self: super: {
      jsonschema = super.jsonschema.overridePythonAttrs (oldAttrs: rec {
        version = "3.2.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-yKhbKNN3zHc35G4tnytPRO48Dh3qxr9G3e/HGH0weXo=";
        };

        SETUPTOOLS_SCM_PRETEND_VERSION = version;

        doCheck = false;
      });
    }) defaultOverrides;
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
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "sentry-sdk==1.3.1" "sentry-sdk>=1.3.1" \
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
