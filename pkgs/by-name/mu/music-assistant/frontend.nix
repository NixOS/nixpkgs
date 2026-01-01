{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "music-assistant-frontend";
<<<<<<< HEAD
  version = "2.17.55";
=======
  version = "2.15.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "music_assistant_frontend";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-fRn2hLg0y+G2atyxpzMq86mJJA41nfSS5UweNZL+0ew=";
=======
    hash = "sha256-atwFGd6KplVPw4e6rHrNlXmMCsozL56lCVYVWCg9RPs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "music_assistant_frontend" ];

  meta = {
    changelog = "https://github.com/music-assistant/frontend/releases/tag/${version}";
    description = "Music Assistant frontend";
    homepage = "https://github.com/music-assistant/frontend";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
