{
  stdenv,
  lib,
  fetchFromGitHub,
  gnum4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nvidia-modprobe";
  version = "595.45.04";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = finalAttrs.version;
    hash = "sha256-DDeSu6R1JsUux77LfsrAVBTwW6MPu6P1v8W4o2VCN2g=";
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
