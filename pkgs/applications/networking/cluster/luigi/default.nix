{ lib, python3 }:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      tornado = super.tornado_5;
    };
  };
in with python.pkgs; buildPythonApplication rec {
  pname = "luigi";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02c480f5pjgqsvqnkaw7f6n4nhdspmhq5w7lw8sgg2v3jghg8n7i";
  };

  propagatedBuildInputs = [ dateutil tornado_5 python-daemon boto3 ];

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
