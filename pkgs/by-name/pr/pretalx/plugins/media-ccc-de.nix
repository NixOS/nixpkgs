{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-media-ccc-de";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-media-ccc-de";
    rev = "v${version}";
    hash = "sha256-Cr9qbkb1VOH2EtDLSA5jmLiCnn1ICdvHnmTugCvHLc0=";
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
