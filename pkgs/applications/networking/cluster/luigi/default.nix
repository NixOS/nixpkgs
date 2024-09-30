{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonApplication rec {
  pname = "luigi";
  version = "3.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0AD+am6nfJN2Z0/oegRawAw/z36+hBRlWgZjCqnbURE=";
  };

  build-system = [ python3.pkgs.setuptools ];

  dependencies = with python3.pkgs; [ python-dateutil tornado python-daemon tenacity ];

  pythonImportsCheck = [ "luigi" ];

  # Requires tox, hadoop, and google cloud
  doCheck = false;

  # This enables accessing modules stored in cwd
  makeWrapperArgs = [ "--prefix PYTHONPATH . :" ];

  meta = with lib; {
    description = "Python package that helps you build complex pipelines of batch jobs";
    longDescription = ''
      Luigi handles dependency resolution, workflow management, visualization,
      handling failures, command line integration, and much more.
    '';
    homepage = "https://github.com/spotify/luigi";
    changelog = "https://github.com/spotify/luigi/releases/tag/${version}";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.bhipple ];
  };
}
