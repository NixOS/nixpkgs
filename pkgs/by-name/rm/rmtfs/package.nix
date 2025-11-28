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
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "andersson";
    repo = "rmtfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-00KOjdkwcAER261lleSl7OVDEAEbDyW9MWxDd0GI8KA=";
  };

  buildInputs = [
    udev
    qrtr
    qmic
  ];

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewcroughan ];
    description = "Qualcomm Remote Filesystem Service";
    homepage = "https://github.com/linux-msm/rmtfs";
    license = licenses.bsd3;
    platforms = platforms.aarch64;
  };
})
