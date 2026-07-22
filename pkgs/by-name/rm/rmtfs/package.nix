{
  stdenv,
  lib,
  fetchFromGitHub,
  udev,
  qrtr,
  qmic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rmtfs";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "rmtfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j92qz4x5KTYXjcvFGPp4YbmcM0pz2pUlV2tCsT8FV0I=";
  };

  buildInputs = [
    udev
    qrtr
    qmic
  ];

  installFlags = [ "prefix=$(out)" ];

  meta = {
    maintainers = with lib.maintainers; [ matthewcroughan ];
    description = "Qualcomm Remote Filesystem Service";
    homepage = "https://github.com/linux-msm/rmtfs";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.aarch64;
    mainProgram = "rmtfs";
  };
})
