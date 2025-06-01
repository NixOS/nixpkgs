{
  stdenv,
  lib,
  fetchFromGitHub,
  gnum4,
}:
stdenv.mkDerivation rec {
  pname = "nvidia-modprobe";
  version = "575.57.08";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = version;
    hash = "sha256-KpHhPFl+cNTQpld9LtI9yLidN9gj1zNz+jKfzF+n+sI=";
  };

  nativeBuildInputs = [ gnum4 ];

  postPatch = ''
    substituteInPlace utils.mk --replace-fail "/usr/local" "$out"
  '';

  meta = {
    description = "Load the NVIDIA kernel module and create NVIDIA character device files ";
    homepage = "https://github.com/NVIDIA/nvidia-modprobe";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
