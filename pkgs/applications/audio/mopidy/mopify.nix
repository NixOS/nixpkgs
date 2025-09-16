{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-mopify";
  version = "1.7.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Mopify";
    hash = "sha256-RlCC+39zC+LeA/QDWPHYx5TrEwOgVrnvcH1Xg12qSLE=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.configobj
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "mopidy_mopify" ];

  meta = with lib; {
    homepage = "https://github.com/dirkgroenen/mopidy-mopify";
    description = "Mopidy webclient based on the Spotify webbased interface";
    license = licenses.gpl3;
    maintainers = [ maintainers.Gonzih ];
  };
}
