{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "infisicalsdk";
<<<<<<< HEAD
  version = "1.0.14";
=======
  version = "1.0.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Infisical";
    repo = "python-sdk-official";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oQdrrNJ8eoV5JWG7pTP3V8ptLg93DGCgWnTU9AVRG2Q=";
=======
    hash = "sha256-iapdd59Bsz80yRuEWY6zIVYrsoz+WMEOUymmVHzUOd8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    python-dateutil
    aenum
    requests
    boto3
    botocore
  ];

  doCheck = false;
  pythonImportsCheck = [ "infisical_sdk" ];

  meta = {
    homepage = "https://github.com/Infisical/python-sdk-official";
    description = "Infisical Python SDK";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
}
