{
  lib,
  python3Packages,
  fetchPypi,
  fetchgit,
  patatt,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "b4";
  version = "0.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-BxgjoekEUIpv2ar4zC+akml+HfonAAC00RMAFbVvQTc=";
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
    textual
    pygit2
    ezgb
    liblore
  ];

  passthru = {
    src-misc = fetchgit {
      url = "https://git.kernel.org/pub/scm/utils/b4/b4.git";
      rev = "v${finalAttrs.version}";
      hash = "sha256-NjYL3RKQpjDkU98qbXyl/cvLTJYVAfIowm8E2Rg8AgI=";
      fetchSubmodules = false;
    };
  };

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
})
