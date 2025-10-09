{
  lib,
  python3,
  fetchPypi,
  fetchFromGitHub,
  clang,
  clang-tools,
  cppcheck,
  gcc,
  makeWrapper,
  withClang ? false,
  withClangTools ? false,
  withCppcheck ? false,
  withGcc ? false,
}:
let
  python = python3.override {
    packageOverrides = self: super: rec {
      # codechecker is incompatible with SQLAlchemy greater than 1.3
      sqlalchemy = super.sqlalchemy_1_4.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.23";
        pname = oldAttrs.pname;
        src = fetchFromGitHub {
          owner = "sqlalchemy";
          repo = "sqlalchemy";
          rev = "rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
          hash = "sha256-hWA0/f7rQpEfYTg10i0rBK3qeJbw3p6HW7S59rLnD0Q=";
        };
        doCheck = false;
        # That test does not exist in the 1.3 branch so we get an error for disabling it
        disabledTestPaths = builtins.filter (
          testPath: testPath != "test/ext/mypy"
        ) oldAttrs.disabledTestPaths;
      });
      sqlalchemy_1_4 = sqlalchemy;

      # The current alembic version is not compatible with SQLAlchemy 1.3 so we need to downgrade it
      alembic = super.alembic.overridePythonAttrs (oldAttrs: rec {
        pname = "alembic";
        version = "1.5.5";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-3wAowZJ1os/xN+OWF6Oc3NvRFzczuHtr+iV7fAhgITs=";
        };
        doCheck = false;
        dependencies = oldAttrs.dependencies ++ [
          super.python-dateutil
          super.python-editor
        ];
      });
    };
  };
  python3Packages = python.pkgs;
in
python3Packages.buildPythonApplication rec {
  pname = "codechecker";
  version = "6.24.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ftZACUf2lAHokcUXj45LRA7/3goOcIy521cGl6qhR98=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    distutils # required in python312 to call subcommands (see https://github.com/Ericsson/codechecker/issues/4350)
    lxml
    sqlalchemy
    alembic
    portalocker
    psutil
    multiprocess
    thrift
    gitpython
    types-pyyaml
    sarif-tools
    pytest
    pycodestyle
    pylint
    mkdocs
    coverage
  ];

  pythonRelaxDeps = [
    "thrift"
    "portalocker"
    "types-pyyaml"
    "lxml"
    "psutil"
    "multiprocess"
    "gitpython"
    "sarif-tools"
    "pyyaml"
  ];

  postInstall = ''
    wrapProgram "$out/bin/CodeChecker" --prefix PATH : ${
      lib.makeBinPath (
        [ ]
        ++ lib.optional withClang clang
        ++ lib.optional withClangTools clang-tools
        ++ lib.optional withCppcheck cppcheck
        ++ lib.optional withGcc gcc
      )
    }
  '';

  meta = {
    homepage = "https://github.com/Ericsson/codechecker";
    changelog = "https://github.com/Ericsson/codechecker/releases/tag/v${version}";
    description = "Analyzer tooling, defect database and viewer extension for the Clang Static Analyzer and Clang Tidy";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [
      zebreus
      felixsinger
    ];
    mainProgram = "CodeChecker";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
