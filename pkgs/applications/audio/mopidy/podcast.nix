{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-podcast";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Podcast";
    hash = "sha256-grNPVEVM2PlpYhBXe6sabFjWVB9+q+apIRjcHUxH52A=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.cachetools
    pythonPackages.uritools
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_podcast" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/tkem/mopidy-podcast";
    description = "Mopidy extension for browsing and playing podcasts";
    license = lib.licenses.asl20;
    maintainers = [
      lib.maintainers.daneads
=======
  meta = with lib; {
    homepage = "https://github.com/tkem/mopidy-podcast";
    description = "Mopidy extension for browsing and playing podcasts";
    license = licenses.asl20;
    maintainers = [
      maintainers.daneads
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
}
