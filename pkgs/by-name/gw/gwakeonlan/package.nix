{
  fetchFromGitHub,
  python310Packages,
  wrapGAppsHook,
  gobject-introspection,
  gettext
}:
python310Packages.buildPythonPackage rec {
  pname = "gwakeonlan";
  version = "0.8.5";
  format = "setuptools";

  nativeBuildInputs = [
    wrapGAppsHook
    gettext
    gobject-introspection
  ];
  propagatedBuildInputs = with python310Packages; [
    pyxdg
    pygobject3
  ];

  doCheck = false;

  src = fetchFromGitHub {
    repo = "gwakeonlan";
    owner = "muflone";
    rev = "refs/tags/${version}";
    hash = "sha256-e2X6nO0v9ZLV2RIc9S9j215if5TwK0kQpMz1RV8Rekw=";
  };
}

