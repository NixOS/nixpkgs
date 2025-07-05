{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  leanclient = python3.pkgs.buildPythonPackage rec {
    pname = "leanclient";
    version = "0.1.12";
    pyproject = true;

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-yPALTn0WG9D6fT6jDInRt0y10/iyNIUuPEo42srLcIY=";
    };

    build-system = with python3.pkgs; [
      poetry-core
    ];

    dependencies = with python3.pkgs; [
      orjson
      tqdm
    ];

    doCheck = false;

    meta = {
      description = "Lean client library for Python";
      homepage = "https://pypi.org/project/leanclient/";
      license = lib.licenses.mit;
    };
  };

  mcp = python3.pkgs.mcp.overridePythonAttrs (old: rec {
    version = "1.10.0";
    src = python3.pkgs.fetchPypi {
      pname = "mcp";
      inherit version;
      sha256 = "sha256-kfsWI8P68UV3Yj0UdV0yE9uDfF2l2uhQaeG1kSTL4Ok=";
    };
    dependencies =
      (old.dependencies or [ ])
      ++ (with python3.pkgs; [
        jsonschema
        python-multipart
      ]);
    dontCheckRuntimeDeps = true;
    doCheck = false;
  });

in
python3.pkgs.buildPythonApplication rec {
  pname = "lean-lsp-mcp";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hCEbVoxiUBRysDiNvZyx9nZTxbaAQsgsQTiQvhyLosM=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    leanclient
    mcp
  ];

  doCheck = false;
  dontCheckRuntimeDeps = true;

  meta = {
    description = "Lean Theorem Prover MCP (Model Context Protocol) server";
    longDescription = ''
      A Model Context Protocol (MCP) server that provides access to Lean 4 theorem prover
      functionality. This allows AI assistants and other tools to interact with Lean projects,
      query definitions, and get theorem proving assistance.
    '';
    homepage = "https://github.com/oOo0oOo/lean-lsp-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wvhulle ];
    mainProgram = "lean-lsp-mcp";
  };
}
