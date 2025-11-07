{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
  fetchpatch,
}:

let
  packageOverrides = self: super: {
    tomlkit = super.tomlkit.overridePythonAttrs (oldAttrs: rec {
      version = "0.12.5";
      src = fetchPypi {
        pname = "tomlkit";
        inherit version;
        hash = "sha256-7vNPujmDTU1rc8m6fz5NHEF6Tlb4mn6W4JDdDSS4+zw=";
      };
      patches = [
        (fetchpatch {
          url = "https://github.com/python-poetry/tomlkit/commit/05d9be1c2b2a95a4eb3a53d999f1483dd7abae5a.patch";
          hash = "sha256-9pLGxcGHs+XoKrqlh7Q0dyc07XrK7J6u2T7Kvfd0ICc=";
          excludes = [ ".github/workflows/tests.yml" ];
        })
      ];
    });
  };
  python = python3Packages.python.override (oa: {
    self = python3Packages.python;
    packageOverrides = lib.composeExtensions (oa.packageOverrides or (_: _: { })) packageOverrides;
  });
  pythonPackages = python.pkgs;
in
pythonPackages.buildPythonApplication rec {
  pname = "remarshal";
  version = "0.17.1"; # last version with YAML 1.1 support, do not update
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "remarshal";
    tag = "v${version}";
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

  meta = {
    changelog = "https://github.com/remarshal-project/remarshal/releases/tag/v${version}";
    description = "Convert between TOML, YAML and JSON";
    license = lib.licenses.mit;
    homepage = "https://github.com/dbohdan/remarshal";
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "remarshal";
  };
}
