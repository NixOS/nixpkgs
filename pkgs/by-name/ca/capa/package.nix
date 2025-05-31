{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "capa";
  version = "9.1.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "flare_capa";
    version = "${version}";
    hash = "sha256-ffXIAzuepWhWlhG18ZSLglfAVaGRoBqx5nzj5AfIbiE=";
  };

  propagatedBuildInputs =
    with python3Packages;
    let
      # ida-settings not packaged in nixpkgs
      ida-settings = buildPythonPackage rec {
        pname = "ida-settings";
        version = "2.1.0";
        src = fetchPypi {
          pname = "ida-settings";
          version = "${version}";
          hash = "sha256-E3FzC05kvziIRbZaQb6glOveil06Bb307fL0KquoMmI=";
        };
      };
    in
    [
      colorama
      dncil
      dnfile
      humanize
      ida-settings
      msgspec
      networkx
      pefile
      protobuf
      pydantic
      pyelftools
      pyyaml
      rich
      ruamel-yaml
      setuptools
      setuptools-scm
      viv-utils
      vivisect
      xmltodict
    ];

  meta = with lib; {
    changelog = "https://github.com/mandiant/capa/releases/tag/${version}";
    description = "Open-source tool to identify capabilities in executable files";
    homepage = "https://mandiant.github.io/capa/";
    license = "apache-2.0";
    maintainers = with maintainers; [ heywoodlh ];
    mainProgram = "capa";
  };
}
