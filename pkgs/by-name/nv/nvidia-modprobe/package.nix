{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gnum4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nvidia-modprobe";
  version = "595.71.05";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = finalAttrs.version;
    hash = "sha256-XVWvnUZkEqEh3UjPIU6DaZuYU9DvjfIMsWbLJ78jJWs=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ooonea/nvidia-modprobe/commit/450f0c15ad9229fe5f4d3f80ae4d95e42d9c038e.patch";
      hash = "sha256-SKJqt2MJDQxzRnfGcgB9oJHyt6Rwrm4hLh9zgIPEv/0=";
    })
  ];

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
