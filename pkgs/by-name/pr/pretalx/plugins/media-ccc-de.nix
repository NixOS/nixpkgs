{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-media-ccc-de";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-media-ccc-de";
    rev = "v${version}";
    hash = "sha256-6yX6XoEX8bVQer3E6oH9Dm9A6Sz0x9O4p8uD0RpLPvk=";
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
