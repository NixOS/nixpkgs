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
    owner = "md-raid-utilities";
    repo = "ledmon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d1Mz26i1rID1Z7ctnC5yrE9UnfNdRt6L5lq4bYBJ5dM=";
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
    homepage = "https://github.com/md-raid-utilities/ledmon";
    description = "Enclosure LED Utilities";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sorki ];
  };
})
