{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "luigi";
  version = "2.8.11";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "17nc5xrqp6hp3ayscvdpsiiga8gsfpa4whsk0n97gzk5qpndrcy2";
  };

  propagatedBuildInputs = with python3Packages; [ dateutil tornado_4 python-daemon boto3 ];

  # Requires tox, hadoop, and google cloud
  doCheck = false;

  # This enables accessing modules stored in cwd
  makeWrapperArgs = ["--prefix PYTHONPATH . :"];

  meta = with lib; {
    homepage = https://github.com/spotify/luigi;
    description = "Python package that helps you build complex pipelines of batch jobs";
    longDescription = ''
      Luigi handles dependency resolution, workflow management, visualization,
      handling failures, command line integration, and much more.
    '';
    license =  [ licenses.asl20 ];
    maintainers = [ maintainers.bhipple ];
  };
}
