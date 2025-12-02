{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "pretalx-pages";
  version = "1.7.0-unstable-2025-10-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-pages";
    rev = "58cfe9b227a5cf5597c30285500546d2d3d84b8a";
    hash = "sha256-kfGdb7vcUvK4yXqJd1XftTNWPLvjE4zrZSy4xgrmkMg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_pages" ];

  meta = {
    description = "Static pages for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-pages";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
