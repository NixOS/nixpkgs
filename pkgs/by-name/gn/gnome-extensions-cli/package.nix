{
  lib,
  fetchPypi,
  python3Packages,
  gobject-introspection,
  wrapGAppsNoGuiHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gnome-extensions-cli";
  version = "0.10.8";
  pyproject = true;

  src = fetchPypi {
    pname = "gnome_extensions_cli";
    inherit (finalAttrs) version;
    hash = "sha256-Tnf8BbW9u7d19ZtGTdMVHa6azbKekYRGOPEPNiB+y00=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsNoGuiHook
  ];

  pythonRelaxDeps = [
    "more-itertools"
    "packaging"
  ];

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = [
    python3Packages.colorama
    python3Packages.packaging
    python3Packages.pydantic
    python3Packages.requests
    python3Packages.pygobject3
    python3Packages.tqdm
  ];

  pythonImportsCheck = [
    "gnome_extensions_cli"
  ];

  meta = {
    homepage = "https://github.com/essembeh/gnome-extensions-cli";
    description = "Command line tool to manage your GNOME Shell extensions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    platforms = lib.platforms.linux;
  };
})
