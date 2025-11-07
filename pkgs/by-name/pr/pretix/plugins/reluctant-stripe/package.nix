{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage {
  pname = "pretix-reluctant-stripe";
  version = "0-unstable-2023-08-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metarheinmain";
    repo = "pretix-reluctant-stripe";
    rev = "ae2d770442553e5fc00815ff4521a8fd2c113fd9";
    hash = "sha256-bw9aDMxl4/uar5KHjj+wwkYkaGMRxHWY/c1N75bxu0o=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretix_reluctant_stripe"
  ];

  meta = with lib; {
    description = "Nudge users to not use Stripe as a payment provider";
    homepage = "https://github.com/metarheinmain/pretix-reluctant-stripe";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
