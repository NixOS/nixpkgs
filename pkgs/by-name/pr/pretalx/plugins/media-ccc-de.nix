{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-media-ccc-de";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-media-ccc-de";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QyX/hmDom2QHiaTH0EFg2jxzochQaFQ4AOQ2vM6yofU=";
=======
    hash = "sha256-76hxS9cYvaRcToD8ooW0Fnp36+7n17j3UR1VD9v2zR8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_media_ccc_de" ];

  meta = {
    description = "Pull recordings from media.ccc.de and embed them in talk pages";
    homepage = "https://github.com/pretalx/pretalx-media-ccc-de";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
