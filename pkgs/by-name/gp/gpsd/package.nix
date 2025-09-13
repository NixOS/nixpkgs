{
  stdenv,
  lib,
  fetchurl,

  # nativeBuildInputs
  scons,
  pkg-config,

  # buildInputs
  dbus,
  libusb1,
  ncurses,
  kppsSupport ? stdenv.hostPlatform.isLinux,
  pps-tools,
  python3Packages,

  # optional deps for GUI packages
  guiSupport ? true,
  dbus-glib,
  libX11,
  libXt,
  libXpm,
  libXaw,
  libXext,
  gobject-introspection,
  pango,
  gdk-pixbuf,
  atk,
  wrapGAppsHook3,

  gpsdUser ? "gpsd",
  gpsdGroup ? "dialout",
}:

stdenv.mkDerivation rec {
  pname = "gpsd";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-3H5GWWjBVA5hvFfHWG1qV6AEchKgFO/a00j5B7wuCZA=";
  };

  # TODO: render & install HTML documentation using asciidoctor
  nativeBuildInputs = [
    pkg-config
    python3Packages.wrapPython
    scons
  ]
  ++ lib.optionals guiSupport [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    libusb1
    ncurses
    python3Packages.python
  ]
  ++ lib.optionals kppsSupport [
    pps-tools
  ]
  ++ lib.optionals guiSupport [
    atk
    dbus-glib
    gdk-pixbuf
    libX11
    libXaw
    libXext
    libXpm
    libXt
    pango
  ];

  pythonPath = [
    python3Packages.pyserial
  ]
  ++ lib.optionals guiSupport [
    python3Packages.pygobject3
    python3Packages.pycairo
  ];

  patches = [
    ./sconstruct-env-fixes.patch
    ./sconstrict-rundir-fixes.patch
  ];

  preBuild = ''
    patchShebangs .
    sed -e "s|systemd_dir = .*|systemd_dir = '$out/lib/systemd/system'|" -i SConscript
    export TAR=noop
    substituteInPlace SConscript --replace "env['CCVERSION']" "env['CC']"
  '';

  # - leapfetch=no disables going online at build time to fetch leap-seconds
  #   info. See <gpsd-src>/build.txt for more info.
  sconsFlags = [
    "leapfetch=no"
    "gpsd_user=${gpsdUser}"
    "gpsd_group=${gpsdGroup}"
    "systemd=yes"
    "xgps=${if guiSupport then "True" else "False"}"
    "udevdir=${placeholder "out"}/lib/udev"
    "python_libdir=${placeholder "out"}/${python3Packages.python.sitePackages}"
  ];

  preCheck = ''
    export LD_LIBRARY_PATH="$PWD"
  '';

  # TODO: the udev rules file and the hotplug script need fixes to work on NixOS
  preInstall = ''
    mkdir -p "$out/lib/udev/rules.d"
  '';

  doInstallCheck = true;

  installTargets = [
    "install"
    "udev-install"
  ];

  # remove binaries for x-less install because xgps sconsflag is partially broken
  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = {
    description = "GPS service daemon";
    longDescription = ''
      gpsd is a service daemon that monitors one or more GPSes or AIS
      receivers attached to a host computer through serial or USB ports,
      making all data on the location/course/velocity of the sensors
      available to be queried on TCP port 2947 of the host computer. With
      gpsd, multiple location-aware client applications (such as navigational
      and wardriving software) can share access to receivers without
      contention or loss of data. Also, gpsd responds to queries with a
      format that is substantially easier to parse than the NMEA 0183 emitted
      by most GPSes. The gpsd distribution includes a linkable C service
      library, a C++ wrapper class, and a Python module that developers of
      gpsd-aware applications can use to encapsulate all communication with
      gpsd. Third-party client bindings for Java and Perl also exist.

      Besides gpsd itself, the project provides auxiliary tools for
      diagnostic monitoring and profiling of receivers and feeding
      location-aware applications GPS/AIS logs for diagnostic purposes.
    '';
    homepage = "https://gpsd.gitlab.io/gpsd/index.html";
    changelog = "https://gitlab.com/gpsd/gpsd/-/blob/release-${version}/NEWS";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bjornfor
      rasendubi
    ];
  };
}
