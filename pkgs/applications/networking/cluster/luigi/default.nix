{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "luigi";
  version = "2.7.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "035w8gqql36zlan0xjrzz9j4lh9hs0qrsgnbyw07qs7lnkvbdv9x";
  };

  # Relax version constraint
  postPatch = ''
    sed -i 's/<2.2.0//' setup.py
  '';

  propagatedBuildInputs = with python3Packages; [ tornado_4 python-daemon ];

  # Requires tox, hadoop, and google cloud
  doCheck = false;

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
