{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "luigi";
  version = "3.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QbFIUCI8YZ2QBrMKzacz51a4g/x+YIFCBVdmRxkMluM=";
  };

  build-system = [ python3.pkgs.setuptools ];

  pythonRelaxDeps = [ "tenacity" ];

  dependencies = with python3.pkgs; [
    python-dateutil
    tornado
    python-daemon
    tenacity
  ];

  pythonImportsCheck = [ "luigi" ];

  # Requires tox, hadoop, and google cloud
  doCheck = false;

  # This enables accessing modules stored in cwd
  makeWrapperArgs = [ "--prefix PYTHONPATH . :" ];

  meta = {
    description = "Python package that helps you build complex pipelines of batch jobs";
    longDescription = ''
      Luigi handles dependency resolution, workflow management, visualization,
      handling failures, command line integration, and much more.
    '';
    homepage = "https://github.com/spotify/luigi";
    changelog = "https://github.com/spotify/luigi/releases/tag/${version}";
    license = [ lib.licenses.asl20 ];
  };
}
