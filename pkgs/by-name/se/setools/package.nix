{
  lib,
  fetchFromGitHub,
  python3Packages,
  libsepol,
  libselinux,
  checkpolicy,
  withGraphics ? false,
}:

python3Packages.buildPythonApplication rec {
  pname = "setools";
  version = "4.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = "setools";
    tag = version;
    hash = "sha256-UZisEbHx3zO92gmRQSYsI8TmY9MjCP7AWNAESYklAkk=";
  };

  build-system = with python3Packages; [
    cython
    setuptools
  ];

  buildInputs = [ libsepol ];

  dependencies =
    with python3Packages;
    [
      libselinux
      setuptools
    ]
    ++ lib.optionals withGraphics [ pyqt5 ];

  optional-dependencies = {
    analysis = with python3Packages; [
      networkx
      pygraphviz
    ];
  };

  nativeCheckInputs = [
    python3Packages.tox
    checkpolicy
  ];

  setupPyBuildFlags = [ "-i" ];

  preBuild = ''
    export SEPOL="${lib.getLib libsepol}/lib/libsepol.a"
  '';

  preCheck = ''
    export CHECKPOLICY=${lib.getExe checkpolicy}
  '';

  meta = {
    description = "SELinux Policy Analysis Tools";
    homepage = "https://github.com/SELinuxProject/setools";
    changelog = "https://github.com/SELinuxProject/setools/blob/${version}/ChangeLog";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Plus
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
