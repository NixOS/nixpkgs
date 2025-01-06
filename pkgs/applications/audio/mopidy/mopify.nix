{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Mopify";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RlCC+39zC+LeA/QDWPHYx5TrEwOgVrnvcH1Xg12qSLE=";
  };

  propagatedBuildInputs = with pythonPackages; [
    mopidy
    configobj
  ];

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://github.com/dirkgroenen/mopidy-mopify";
    description = "Mopidy webclient based on the Spotify webbased interface";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.Gonzih ];
  };
}
