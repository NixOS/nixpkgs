{ lib
, python3
, fetchPypi
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      opensearch-py = super.opensearch-py.overridePythonAttrs (oldAttrs: {
        nativeCheckInputs = (oldAttrs.nativeCheckInputs or [ ]) ++ [
          python.pkgs.events
        ];
        dependencies = (oldAttrs.dependencies or [ ]) ++ [
          python.pkgs.events
        ];
      });
      thespian = super.thespian.overridePythonAttrs (oldAttrs: rec {
        pname = "thespian";
        version = "3.10.6";
        src = fetchPypi {
          inherit pname version;
          extension = "zip";
          hash = "sha256-yYeoBCuiMD4iNx84pnNUWT3YHEwRuh66f2ZXQJKI1e0=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "opensearch-benchmark";
  version = "1.7.1";
  pyproject = true;

  src = fetchPypi {
    pname = "opensearch_benchmark";
    inherit version;
    hash = "sha256-a5sNlekrLFo4MAxPNHmdFiaQXXx63O9ChhhAlIdoB3U=";
  };

  nativeBuildInputs = with python.pkgs;[
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python.pkgs;[
    boto3
    certifi
    google-auth
    google-resumable-media
    h5py
    ijson
    jinja2
    jsonschema
    markupsafe
    numpy
    opensearch-py
    opensearch-py.optional-dependencies.async
    psutil
    py-cpuinfo
    tabulate
    thespian
    setuptools
    wheel
    yappi
    zstandard
  ];

  passthru.optional-dependencies = with python.pkgs; {
    develop = [
      coverage
      github3-py
      pylint
      pylint-quotes
      pytest
      pytest-asyncio
      pytest-benchmark
      tox
      twine
      ujson
      wheel
    ];
  };

  meta = {
    description = "Macrobenchmarking framework for OpenSearch";
    homepage = "https://pypi.org/project/opensearch-benchmark/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "opensearch-benchmark";
  };
}
