{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-pages";
<<<<<<< HEAD
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-pages";
    tag = "v${version}";
    hash = "sha256-iRmDYjq08UkA/2pyUUK/DUuNbLNn/KSNQGiU1o1gTWw=";
=======
  version = "1.7.0";
  pyproject = true;

  # TODO: https://github.com/pretalx/pretalx-pages/issues/6
  src = fetchPypi {
    pname = "pretalx_pages";
    inherit version;
    hash = "sha256-XFZS0FUzouZzVh9AADK5dnezFZiAWoBihD4C184+690=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_pages" ];

  meta = {
    description = "Static pages for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-pages";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
