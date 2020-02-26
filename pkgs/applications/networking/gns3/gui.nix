{ stable, branch, version, sha256Hash }:

{ stdenv, python3Packages, fetchFromGitHub }:

let
  pythonPackages = python3Packages;

in pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "gns3-gui";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  propagatedBuildInputs = with pythonPackages; [
    raven psutil jsonschema # tox for check
    # Runtime dependencies
    sip (pyqt5.override { withWebSockets = true; }) setuptools
  ] ++ stdenv.lib.optional (!stable) pythonPackages.distro;

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
