{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-vimeo";
<<<<<<< HEAD
  version = "2.6.0";
=======
  version = "2.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-vimeo";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qj0z6sLIJz0Ug+MN7wGTDZli0CdArhdeGSpp4n/EaHk=";
=======
    hash = "sha256-MwAKmPQif2wLy03II1t87lIdIf2th4BteaAo5pACjLE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_vimeo" ];

  meta = {
    description = "Static vimeo for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-vimeo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
