{
  busybox,
  cmake,
  coreutils,
  dbus,
  fetchFromGitHub,
  gettext,
  graphviz,
  json_c,
  lib,
  libarchive,
  libusb1,
  libxml2,
  makeWrapper,
  ncurses,
  ninja,
  openssl,
  picocom,
  pkg-config,
  qemu,
  socat,
  sqlite,
  stdenv,
  systemd,
  tigervnc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nemu";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "nemuTUI";
    repo = "nemu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6WzqBkspKKs1e8kg1i71ntZHa78s5pJ1u02mXvzpiEc=";
  };

  cmakeFlags = [
    "-DNM_WITH_DBUS=ON"
    "-DNM_WITH_NETWORK_MAP=ON"
    "-DNM_WITH_REMOTE=ON"
    "-DNM_WITH_USB=ON"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    busybox # for start-stop-daemon
    coreutils
    dbus
    gettext
    graphviz
    json_c
    libarchive
    libusb1
    libxml2
    ncurses
    openssl
    picocom
    qemu
    socat
    sqlite
    systemd # for libudev
    tigervnc
  ];

  runtimeDependencies = [
    busybox
    picocom
    qemu
    socat
    tigervnc
  ];

  postPatch = ''
    substituteInPlace nemu.cfg.sample \
      --replace-fail /usr/bin/vncviewer ${tigervnc}/bin/vncviewer \
      --replace-fail "qemu_bin_path = /usr/bin" "qemu_bin_path = ${qemu}/bin"

    substituteInPlace sh/ntty \
      --replace-fail /usr/bin/socat ${socat}/bin/socat \
      --replace-fail /usr/bin/picocom ${picocom}/bin/picocom \
      --replace-fail start-stop-daemon ${busybox}/bin/start-stop-daemon

    substituteInPlace sh/setup_nemu_nonroot.sh \
      --replace-fail /usr/bin/nemu $out/bin/nemu
  '';

  postInstall = ''
    wrapProgram $out/share/nemu/scripts/upgrade_db.sh \
      --prefix PATH : "${sqlite}/bin"
  '';

  meta = {
    changelog = "https://github.com/nemuTUI/nemu/releases/tag/v${finalAttrs.version}";
    description = "Ncurses UI for QEMU";
    homepage = "https://github.com/nemuTUI/nemu";
    license = lib.licenses.bsd2;
    mainProgram = "nemu";
    maintainers = with lib.maintainers; [ msanft ];
    platforms = lib.platforms.unix;
  };
})
