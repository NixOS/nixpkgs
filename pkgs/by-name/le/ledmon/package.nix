{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  udev,
  sg3_utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ledmon";
  version = "0.92";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ledmon";
    rev = "v${finalAttrs.version}";
    sha256 = "1lz59606vf2sws5xwijxyffm8kxcf8p9qbdpczsq1b5mm3dk6lvp";
  };

  nativeBuildInputs = [
    perl # for pod2man
  ];
  buildInputs = [
    udev
    sg3_utils
  ];

  installTargets = [
    "install"
    "install-systemd"
  ];

  makeFlags = [
    "MAN_INSTDIR=${placeholder "out"}/share/man"
    "SYSTEMD_SERVICE_INSTDIR=${placeholder "out"}/lib/systemd/system"
    "LEDCTL_INSTDIR=${placeholder "out"}/sbin"
    "LEDMON_INSTDIR=${placeholder "out"}/sbin"
  ];

  meta = {
    homepage = "https://github.com/intel/ledmon";
    description = "Enclosure LED Utilities";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ sorki ];
  };
})
