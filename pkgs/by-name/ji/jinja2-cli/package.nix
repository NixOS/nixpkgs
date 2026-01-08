{
  lib,
  python3,
  fetchFromGitHub,
  extras ? [
    "hjson"
    "json5"
    "xml"
    "yaml"
  ],
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jinja2-cli";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mattrobenolt";
    repo = "jinja2-cli";
    rev = "v${version}";
    hash = "sha256-m7auOnk618sXet4paRJmQKVEp0LLi+7PIWx8P8IUQf0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.9.21,<0.10.0' 'uv_build>=0.9.9,<0.10.0'
  '';

  build-system = [ python3.pkgs.uv-build ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      jinja2
    ]
    ++ lib.attrVals extras optional-dependencies;

  pythonImportsCheck = [ "jinja2cli" ];

  optional-dependencies = with python3.pkgs; {
    hjson = [ hjson ];
    json5 = [ json5 ];
    xml = [ xmltodict ];
    yaml = [ pyyaml ];
  };

  meta = {
    description = "The CLI for Jinja2";
    homepage = "https://github.com/mattrobenolt/jinja2-cli";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.mattrobenolt ];
    mainProgram = "jinja2";
  };
}
