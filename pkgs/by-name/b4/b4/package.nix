{
  lib,
  python3Packages,
  fetchPypi,
  patatt,
}:

python3Packages.buildPythonApplication rec {
  pname = "b4";
  version = "0.14.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T4NbblrjDv9gBLslwV/Y9Pbs0RBVluhtsYcf730YET0=";
  };

  # tests make dns requests and fails
  doCheck = false;

  build-system = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    requests
    dnspython
    dkimpy
    patatt
    git-filter-repo
  ];

  meta = {
    homepage = "https://git.kernel.org/pub/scm/utils/b4/b4.git/about";
    license = lib.licenses.gpl2Only;
    description = "Helper utility to work with patches made available via a public-inbox archive";
    mainProgram = "b4";
    maintainers = with lib.maintainers; [
      jb55
      qyliss
      mfrw
    ];
  };
}
