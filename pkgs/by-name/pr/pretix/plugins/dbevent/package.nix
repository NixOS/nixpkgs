{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretix-dbevent";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-dbevent";
    rev = "v${version}";
    hash = "sha256-1WUTunDeRh0+hPOF/uLcPmRlUlHAOhOqeoYQNYv0ZLI=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretix_dbevent"
  ];

  meta = {
    description = "Advertise the DB Event Offers for discounted and sustainable train travel to your attendees";
    homepage = "https://github.com/pretix/pretix-dbevent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      e1mo
      hexa
    ];
  };
}
