{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretix-dbvat";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-dbvat";
    rev = "v${version}";
    hash = "sha256-yAKqB0G2WyGqGogAxv8fI34gO6Wl/50sY/5rvWYH4Ho=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretix_dbvat"
  ];

  meta = with lib; {
    description = "Plugin for using Deutsche Bahn (DB) Event Discount (Veranstaltungsrabatt)";
    homepage = "https://github.com/pretix/pretix-dbvat";
    license = licenses.asl20;
    maintainers = with maintainers; [ e1mo ];
  };
}
