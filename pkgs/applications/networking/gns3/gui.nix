{ stdenv, python34Packages, fetchFromGitHub }:

# TODO: Python 3.6 was failing
python34Packages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "gns3-gui";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "10qp6430md8d0h2wamgfaq7pai59mqmcw6sw3i1gvb20m0avvsvb";
  };

  propagatedBuildInputs = with python34Packages; [
    raven psutil jsonschema # tox for check
    # Runtime dependencies
    sip pyqt5
  ];

  doCheck = false; # Failing

  meta = with stdenv.lib; {
    description = "Graphical Network Simulator";
    #longDescription = ''
    #  ...
    #'';
    homepage = "https://www.gns3.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
