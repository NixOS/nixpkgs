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

  buildInputs = [
    udev
    qrtr
    qmic
  ];

  src = fetchFromGitHub {
    owner = "andersson";
    repo = "rmtfs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-00KOjdkwcAER261lleSl7OVDEAEbDyW9MWxDd0GI8KA=";
  };

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewcroughan ];
    description = "Qualcomm Remote Filesystem Service";
    homepage = "https://github.com/linux-msm/rmtfs";
    license = licenses.bsd3;
    platforms = platforms.aarch64;
  };
})
