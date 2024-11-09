{ lib
, python3
, fetchFromGitHub
, extras ? [ "hjson" "json5" "toml" "xml" "yaml" ]
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jinja2-cli";
  version = "0.8.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mattrobenolt";
    repo = "jinja2-cli";
    rev = version;
    hash = "sha256-67gYt0nZX+VTVaoSxVXGzbRiXD7EMsVBFWC8wHo+Vw0=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    jinja2
  ] ++ lib.attrVals extras optional-dependencies;

  pythonImportsCheck = [ "jinja2cli" ];

  optional-dependencies = with python3.pkgs; {
    hjson = [ hjson ];
    json5 = [ json5 ];
    toml = [ toml ];
    xml = [ xmltodict ];
    yaml = [ pyyaml ];
  };

  meta = with lib; {
    description = "CLI for Jinja2";
    homepage = "https://github.com/mattrobenolt/jinja2-cli";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "jinja2";
  };
}
