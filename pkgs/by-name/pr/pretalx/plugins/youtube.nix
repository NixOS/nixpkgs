{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-youtube";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-youtube";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vOgzYxF3MHzzcUb8TMLRSyuRc6RHcxvCWxAFRFAf1Cs=";
=======
    hash = "sha256-5vQPFW0qABKQjFUvjMrtmIGEpMzLLbAOBA4GFqqBNw0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_youtube" ];

  meta = {
    description = "Static youtube for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-youtube";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
