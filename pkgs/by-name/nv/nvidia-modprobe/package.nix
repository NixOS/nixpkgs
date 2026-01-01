{
  stdenv,
  lib,
  fetchFromGitHub,
  gnum4,
}:
stdenv.mkDerivation rec {
  pname = "nvidia-modprobe";
<<<<<<< HEAD
  version = "590.48.01";
=======
  version = "580.105.08";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Vtp5FDDmzbwtDe11O0w/S8Mptpp8Li21/gBfJzfE0/g=";
=======
    hash = "sha256-orOFwL9mrmqPqMorUOZlBTMEraAqYCf+2XTD9DuMeSk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ gnum4 ];

  postPatch = ''
    substituteInPlace utils.mk --replace-fail "/usr/local" "$out"
  '';

  meta = {
<<<<<<< HEAD
    description = "Load the NVIDIA kernel module and create NVIDIA character device files";
=======
    description = "Load the NVIDIA kernel module and create NVIDIA character device files ";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/NVIDIA/nvidia-modprobe";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
