{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gettext,
  setuptools,
  django,
  pyjwt,
}:

buildPythonPackage rec {
  pname = "pretalx-venueless";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-venueless";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oV7J5ndhrhrI5UXTDexLMRo7Gud4SyppCKhoUtom54E=";
=======
    hash = "sha256-1YWkyTaImnlGXZWrborvJrx8zc1FOZD/ugOik7S+fC8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ gettext ];

  build-system = [ setuptools ];

  dependencies = [
    django
    pyjwt
  ];

  pythonImportsCheck = [ "pretalx_venueless" ];

  meta = {
    description = "Static venueless for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-venueless";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
