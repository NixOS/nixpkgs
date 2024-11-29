{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "cinemagoer";
  version = "2023.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XOHXeuZUZwFhjxHlsVVqGdGO3srRttfZaXPsNJQbGPI=";
  };

  propagatedBuildInputs = [
    lxml
    sqlalchemy
  ];

  # Tests require networking, and https://github.com/cinemagoer/cinemagoer/issues/240
  doCheck = false;

  pythonImportsCheck = [ "imdb" ]; # Former "imdbpy", upstream is yet to rename here

  meta = with lib; {
    description = "Python package for retrieving and managing the data of the IMDb movie database about movies and people";
    downloadPage = "https://github.com/cinemagoer/cinemagoer/";
    homepage = "https://cinemagoer.github.io/";
    license = licenses.gpl2Only;
    maintainers = [ ];
  };
}
