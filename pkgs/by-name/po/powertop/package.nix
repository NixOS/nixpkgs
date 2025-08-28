{
  lib,
  stdenv,
  autoconf-archive,
  autoreconfHook,
  fetchFromGitHub,
  gettext,
  libnl,
  ncurses,
  nix-update-script,
  pciutils,
  pkg-config,
  powertop,
  testers,
  xorg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "powertop";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "fenrus75";
    repo = "powertop";
    tag = "v${version}";
    hash = "sha256-53jfqt0dtMqMj3W3m6ravUTzApLQcljDHfdXejeZa4M=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gettext
    libnl
    ncurses
    pciutils
    zlib
  ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace-fail "/sbin/modprobe" "modprobe"
    substituteInPlace src/calibrate/calibrate.cpp --replace-fail "/usr/bin/xset" "${lib.getExe xorg.xset}"
    substituteInPlace src/tuning/bluetooth.cpp --replace-fail "/usr/bin/hcitool" "hcitool"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = powertop;
      command = "powertop --version";
      inherit version;
    };
  };

  meta = {
    inherit (src.meta) homepage;
    changelog = "https://github.com/fenrus75/powertop/releases/tag/v${version}";
    description = "Analyze power consumption on Intel-based laptops";
    mainProgram = "powertop";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      fpletz
      anthonyroussel
    ];
    platforms = lib.platforms.linux;
  };
}
