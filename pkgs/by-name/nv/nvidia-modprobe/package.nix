{
  stdenv,
  lib,
  fetchFromGitHub,
  gnum4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nvidia-modprobe";
  version = "615.71.09";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = finalAttrs.version;
    hash = "sha256-aj8GeAdRqX5/zSHkaqfETjklbphVR7EH1oEqABQIlOs=";
  };

  nativeBuildInputs = [ gnum4 ];

  postPatch = ''
    substituteInPlace utils.mk --replace-fail "/usr/local" "$out"
  '';

  meta = {
    description = "Load the NVIDIA kernel module and create NVIDIA character device files";
    homepage = "https://github.com/NVIDIA/nvidia-modprobe";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
