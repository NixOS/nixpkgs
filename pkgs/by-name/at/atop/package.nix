{
  lib,
  stdenv,
  fetchurl,
  glib,
  zlib,
  ncurses,
  pkg-config,
  findutils,
  systemd,
  python3,
  nixosTests,
  # makes the package unfree via pynvml
  withAtopgpu ? false,
}:

stdenv.mkDerivation rec {
  pname = "atop";
  version = "2.11.0";

  src = fetchurl {
    url = "https://www.atoptool.nl/download/atop-${version}.tar.gz";
    hash = "sha256-m5TGZmAu//e/QC7M5wbDR/OMOctjSY+dOWJoYeVkbiA=";
  };

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals withAtopgpu [
      python3.pkgs.wrapPython
    ];

  buildInputs =
    [
      glib
      zlib
      ncurses
    ]
    ++ lib.optionals withAtopgpu [
      python3
    ];

  pythonPath = lib.optionals withAtopgpu [
    python3.pkgs.pynvml
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "BINPATH=/bin"
    "SBINPATH=/bin"
    "MAN1PATH=/share/man/man1"
    "MAN5PATH=/share/man/man5"
    "MAN8PATH=/share/man/man8"
    "SYSDPATH=/lib/systemd/system"
    "PMPATHD=/lib/systemd/system-sleep"
  ];

  patches = [
    # Fix paths in atop.service, atop-rotate.service, atopgpu.service, atopacct.service,
    # and atop-pm.sh
    ./fix-paths.patch
    # Don't fail on missing /etc/default/atop, make sure /var/log/atop exists pre-start
    ./atop.service.patch
  ];

  preConfigure = ''
    for f in *.{sh,service}; do
      findutils=${findutils} systemd=${systemd} substituteAllInPlace "$f"
    done

    substituteInPlace Makefile --replace 'chown' 'true'
    substituteInPlace Makefile --replace 'chmod 04711' 'chmod 0711'
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall =
    ''
      # Remove extra files we don't need
      rm -r $out/{var,etc} $out/bin/atop{sar,}-${version}
    ''
    + (
      if withAtopgpu then
        ''
          wrapPythonPrograms
        ''
      else
        ''
          rm $out/lib/systemd/system/atopgpu.service $out/bin/atopgpud $out/share/man/man8/atopgpud.8
        ''
    );

  passthru.tests = { inherit (nixosTests) atop; };

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
    description = "Console system performance monitor";
    longDescription = ''
      Atop is an ASCII full-screen performance monitor that is capable of reporting the activity of
      all processes (even if processes have finished during the interval), daily logging of system
      and process activity for long-term analysis, highlighting overloaded system resources by using
      colors, etc. At regular intervals, it shows system-level activity related to the CPU, memory,
      swap, disks and network layers, and for every active process it shows the CPU utilization,
      memory growth, disk utilization, priority, username, state, and exit code.
    '';
    license = licenses.gpl2Plus;
    downloadPage = "http://atoptool.nl/downloadatop.php";
  };
}
