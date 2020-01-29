{ stable, branch, version, sha256Hash, mkOverride }:

{ lib, stdenv, python3, fetchFromGitHub }:

let
  # TODO: This package requires qt5Full to launch
  defaultOverrides = [
    (mkOverride "psutil" "5.6.3"
      "1wv31zly44qj0rp2acg58xbnc7bf6ffyadasq093l455q30qafl6")
    (mkOverride "jsonschema" "2.6.0"
      "00kf3zmpp9ya4sydffpifn0j0mzm342a2vzh82p6r0vh10cg7xbg")
  ];

  python = python3.override {
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) defaultOverrides;
  };
in python.pkgs.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "gns3-gui";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  propagatedBuildInputs = with python.pkgs; [
    raven psutil jsonschema # tox for check
    # Runtime dependencies
    sip (pyqt5.override { withWebSockets = true; }) distro setuptools
  ];

  doCheck = false; # Failing

  meta = with stdenv.lib; {
    description = "Graphical Network Simulator 3 GUI (${branch} release)";
    longDescription = ''
      Graphical user interface for controlling the GNS3 network simulator. This
      requires access to a local or remote GNS3 server (it's recommended to
      download the official GNS3 VM).
    '';
    homepage = https://www.gns3.com/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
