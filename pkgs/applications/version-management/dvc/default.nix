{ lib
, python3Packages
, fetchFromGitHub
, enableGoogle ? false
, enableAWS ? false
, enableAzure ? false
, enableSSH ? false
}:

with python3Packages;
buildPythonApplication rec {
  pname = "dvc";
  version = "0.24.3";

  # PyPi only has wheel
  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc";
    rev = version;
    sha256 = "1wqq4i23hppilp20fx5a5nj93xwf3wwwr2f8aasvn6jkv2l22vpl";
  };

  propagatedBuildInputs = [
    ply
    configparser
    zc_lockfile
    future
    colorama
    configobj
    networkx
    pyyaml
    GitPython
    setuptools
    nanotime
    pyasn1
    schema
    jsonpath_rw
    requests
    grandalf
    asciimatics
    distro
    appdirs
  ]
  ++ lib.optional enableGoogle google_cloud_storage
  ++ lib.optional enableAWS boto3
  ++ lib.optional enableAzure azure-storage-blob
  ++ lib.optional enableSSH paramiko;

  # tests require access to real cloud services
  # nix build tests have to be isolated and run locally
  doCheck = false;

  patches = [ ./dvc-daemon.patch ];

  postPatch = ''
    substituteInPlace dvc/daemon.py --subst-var-by dvc "$out/bin/dcv"
  '';

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    license = licenses.asl20;
    homepage = "https://dvc.org";
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
