{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gnum4,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nvidia-modprobe";
  version = "615.71.09";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    tag = finalAttrs.version;
    hash = "sha256-aj8GeAdRqX5/zSHkaqfETjklbphVR7EH1oEqABQIlOs=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ooonea/nvidia-modprobe/commit/450f0c15ad9229fe5f4d3f80ae4d95e42d9c038e.patch";
      hash = "sha256-SKJqt2MJDQxzRnfGcgB9oJHyt6Rwrm4hLh9zgIPEv/0=";
    })
  ];

  postPatch = ''
    substituteInPlace utils.mk \
      --replace-fail \
        "/usr/local" \
        "$out"
  '';

  nativeBuildInputs = [
    gnum4
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Load the NVIDIA kernel module and create NVIDIA character device files";
    homepage = "https://github.com/NVIDIA/nvidia-modprobe";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.GaetanLepage ];
  };
})
