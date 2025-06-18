{
  lib,
  fetchFromGitHub,
  replaceVars,
  python3Packages,
  testers,
  ansible-cmdb,
}:
let
  inherit (python3Packages)
    setuptools
    mako
    pyyaml
    jsonxs
    buildPythonApplication
    ;

  pname = "ansible-cmdb";
  version = "1.31";
in
buildPythonApplication {
  inherit pname version;

  pyproject = true;

  src = fetchFromGitHub {
    owner = "fboender";
    repo = "ansible-cmdb";
    rev = version;
    hash = "sha256-HOFLX8fiid+xJOVYNyVbz5FunrhteAUPlvS3ctclVHo=";
  };

  patches = [
    (replaceVars ./setup.patch {
      inherit version;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    mako
    pyyaml
    jsonxs
  ];

  passthru.tests.version = testers.testVersion {
    package = ansible-cmdb;
    version = "v${version}";
  };

  meta = {
    description = "Generate host overview from ansible fact gathering output";
    homepage = "https://github.com/fboender/ansible-cmdb";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.tie ];
    mainProgram = "ansible-cmdb";
  };
}
