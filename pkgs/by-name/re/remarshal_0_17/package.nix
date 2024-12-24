{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
}:

let
  python = python3Packages.python.override {
    self = python3Packages.python;
    packageOverrides = self: super: {
      tomlkit = super.tomlkit.overridePythonAttrs (oldAttrs: rec {
        version = "0.12.5";
        src = fetchPypi {
          pname = "tomlkit";
          inherit version;
          hash = "sha256-7vNPujmDTU1rc8m6fz5NHEF6Tlb4mn6W4JDdDSS4+zw=";
        };
      });
    };
  };
  pythonPackages = python.pkgs;
in
pythonPackages.buildPythonApplication rec {
  pname = "remarshal";
  version = "0.17.1"; # last version with YAML 1.1 support, do not update
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "remarshal";
    rev = "refs/tags/v${version}";
    hash = "sha256-2WxMh5P/8NvElymnMU3JzQU0P4DMXFF6j15OxLaS+VA=";
  };

  pythonRemoveDeps = [ "pytest" ];

  build-system = [ pythonPackages.poetry-core ];

  dependencies = with pythonPackages; [
    cbor2
    colorama
    python-dateutil
    pyyaml
    rich-argparse
    ruamel-yaml
    tomlkit
    u-msgpack-python
  ];

  nativeCheckInputs = [ pythonPackages.pytestCheckHook ];

  # nixpkgs-update: no auto update

  meta = with lib; {
    changelog = "https://github.com/remarshal-project/remarshal/releases/tag/v${version}";
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = "https://github.com/dbohdan/remarshal";
    maintainers = with maintainers; [ hexa ];
  };
}
