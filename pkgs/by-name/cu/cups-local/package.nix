{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  libcups3,
  pappl2,
  poppler-utils,
  dbus,
  systemd,
  withDBus ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cups-local";
  version = "3.0b1-unstable-2026-07-01";

  src = fetchFromGitHub {
    owner = "nick-linux8";
    repo = "cups-local";
    rev = "f4b84ea6ea7e5109df7b9c487c78029590e5cd21";
    hash = "sha256-X/FH6GOPOV95pwyqesTZYH0R/WQgsQ32jgnpEqF00SU=";
  };

  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libcups3
    pappl2
    poppler-utils
  ]
  # configure.ac requires BOTH together for HAVE_DBUS
  ++ lib.optionals withDBus [
    dbus
    systemd
  ];

  strictDeps = true;

  configureFlags = [
    "--prefix=${placeholder "out"}"
  ]
  ++ lib.optionals (!withDBus) [ "--disable-dbus" ];

  installFlags = [
    "DBUSDIR=${placeholder "out"}/share/dbus-1"
    "SYSTEMDDIR=${placeholder "out"}/lib/systemd"
  ];

  # Needed to link pow@@GLIBC_2.29 in drivers.o
  env = {
    NIX_LDFLAGS = "-lm";
  };

  postInstall = ''
    mkdir -p $out/bin
    mv $out/sbin/cupslocald $out/bin/cupslocald
    mv $out/sbin/lpadmin    $out/bin/lpadmin
    rmdir $out/sbin 2>/dev/null || true

    wrapProgram "$out/bin/cupslocald" \
     --prefix PATH : "${lib.makeBinPath [ poppler-utils ]}"

  '';

  meta = {
    description = "Unprivileged per-user local print spooler and lp/lpr/lpstat/cancel commands for CUPS 3.0 (alpha quality upstream)";
    homepage = "https://github.com/OpenPrinting/cups-local";
    license = with lib.licenses; [
      asl20
    ];
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.linux;
  };
})
