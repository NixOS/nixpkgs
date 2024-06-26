{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "luigi";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/HkLJ0dRXdGcZz77uOTJrOX0xc3DH45/k9xmfesuxsg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    python-dateutil
    tornado
    python-daemon
    boto3
    tenacity
  ];

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
