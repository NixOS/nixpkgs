{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "luigi";
  version = "3.0.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1km9fnq4pf0iqqcmz94idm0zb3l92zinz0bn6ip86xqhchafd4vf";
  };

  propagatedBuildInputs = with python3Packages; [ dateutil tornado_4 python-daemon boto3 ];

  # Requires tox, hadoop, and google cloud
  doCheck = false;

  # This enables accessing modules stored in cwd
  makeWrapperArgs = ["--prefix PYTHONPATH . :"];

  meta = with lib; {
    description = "Python package that helps you build complex pipelines of batch jobs";
    longDescription = ''
      Luigi handles dependency resolution, workflow management, visualization,
      handling failures, command line integration, and much more.
    '';
    homepage = "https://github.com/spotify/luigi";
    changelog = "https://github.com/spotify/luigi/releases/tag/${version}";
    license =  [ licenses.asl20 ];
    maintainers = [ maintainers.bhipple ];
  };
}
