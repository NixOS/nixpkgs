{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "luigi";
  version = "2.8.12";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1p83mxqs7w5v27a58ps7wji5mlyfz66cpkbyrndix0pv9hdyzpxn";
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
