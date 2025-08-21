{
  stdenv,
  lib,
  fetchFromGitHub,
  gnum4,
}:
stdenv.mkDerivation rec {
  pname = "nvidia-modprobe";
  version = "580.76.05";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = version;
    hash = "sha256-NGVd+uur4jYcnmhIuK5qy0ktm95da89adUQpJbRT3VI=";
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
