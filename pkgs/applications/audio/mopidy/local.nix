{
  lib,
  mopidy,
  python3Packages,
  fetchurl,
  fetchpatch,
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Local";
  version = "3.3.0";

  # We can't use fetchPypi here because the name of the file does not match the
  # name of the package.
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/02/c5/d099a05df7d6b0687071aa7d2d7a3499802b3b4b641531cd46ec8e6e7035/mopidy_local-3.3.0.tar.gz";
    sha256 = "cba6ed6c693952255a9f5efcc7b77d8eae4e4e728c6ee9621efd1a471b992b7a";
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
