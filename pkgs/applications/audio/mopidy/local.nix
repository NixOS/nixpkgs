{
  lib,
  mopidy,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Local";
  version = "3.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "mopidy_local";
    hash = "sha256-y6btbGk5UiVan178x7d9jq5OTnKMbuliHv0aRxuZK3o=";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.uritools
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
