{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-public-voting";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-public-voting";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VslvZkmRy7f+rBd9re46WlmASyk01//N9+jajaSfKG4=";
=======
    hash = "sha256-8l+ugonT0WTHyyMJnU3Vi2QVD2Xxpl286m3YEKu+Ij4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_public_voting" ];

  meta = {
    description = "Public voting plugin for pretalx";
    homepage = "https://github.com/pretalx/pretalx-public-voting";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
