{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  pgdbconn = python3Packages.buildPythonPackage rec {
    pname = "pgdbconn";
    version = "0.8.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "perseas";
      repo = "pgdbconn";
      rev = "v${version}";
      sha256 = "09r4idk5kmqi3yig7ip61r6js8blnmac5n4q32cdcbp1rcwzdn6z";
    };

    build-system = with python3Packages; [ setuptools ];

    # The tests are impure (they try to access a PostgreSQL server)
    doCheck = false;

    dependencies = with python3Packages; [
      psycopg2
    ];
  };
in

python3Packages.buildPythonApplication rec {
  pname = "pyrseas";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "perseas";
    repo = "Pyrseas";
    rev = version;
    sha256 = "sha256-+MxnxvbLMxK1Ak+qKpKe3GHbzzC+XHO0eR7rl4ON9H4=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    psycopg2
    pyyaml
    pgdbconn
  ];

  # The tests are impure (they try to access a PostgreSQL server)
  doCheck = false;

  pythonImportsCheck = [ "pyrseas" ];

  meta = {
    description = "Declarative language to describe PostgreSQL databases";
    homepage = "https://perseas.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pmeunier ];
  };
}
