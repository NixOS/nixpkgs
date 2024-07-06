{
  lib,
  fetchFromGitLab,
  stdenv,
  gitUpdater,
  autoreconfHook,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ethercat";
  version = "1.6.0";

  src = fetchFromGitLab {
    owner = "etherlab.org";
    repo = "ethercat";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-w1aoznLjCHh+dN2fyfpKpzq68B4D/rert2XFpTxk/F4=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  meta = with lib; {
    description = "IgH EtherCAT Master for Linux";
    homepage = "https://etherlab.org/ethercat";
    changelog = "https://gitlab.com/etherlab.org/ethercat/-/blob/1.6-devel/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ stv0g ];
    platforms = platforms.linux;
  };

  configureFlags = [
    # Features
    "--enable-eoe=yes"
    "--enable-cycles=yes"
    "--enable-rtmutex=yes"
    "--enable-hrtimer=yes"
    "--enable-regalias=yes"
    "--enable-refclkop=yes"
    "--enable-tty=no" # Is broken in Kernel 6.6
    "--enable-wildcards"

    # Debugging
    "--enable-debug-if=yes"
    "--enable-debug-ring=no" # Is broken

    # Devices
    "--enable-generic"
    "--enable-ccat"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;
  separateDebugInfo = true;

  passthru.updateScript = gitUpdater { };
})
