{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-media-ccc-de";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-media-ccc-de";
    rev = "v${version}";
    hash = "sha256-76hxS9cYvaRcToD8ooW0Fnp36+7n17j3UR1VD9v2zR8=";
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
