{
  buildPythonPackage,
  drawio-headless,
  fetchPypi,
  isPy3k,
  lib,
  mkdocs,
  poetry-core,
  livereload,
  tornado,
}:

buildPythonPackage rec {
  pname = "mkdocs-drawio-exporter";
  version = "0.9.1";
  pyproject = true;

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "mkdocs_drawio_exporter";
    inherit version;
    hash = "sha256-x8X8hvN/tL8C6VhgMCEHDh2hILjBoyLgQfsFD1+qXgo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    mkdocs
    drawio-headless
    livereload
    tornado
  ];

  pythonImportsCheck = [ "mkdocs_drawio_exporter" ];

  meta = with lib; {
    description = "Exports your Draw.io diagrams at build time for easier embedding into your documentation";
    homepage = "https://github.com/LukeCarrier/mkdocs-drawio-exporter/";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
    longDescription = ''
      Exports your Draw.io diagrams at build time for easier embedding into your documentation.
    '';
  };
}
