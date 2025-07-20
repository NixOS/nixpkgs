{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  systemd,
  unixtools,
  libusb-compat-0_1,
  coreutils,
  wall,
  hostname,
  man,
  enableCgiScripts ? true,
  gd,
  nixosTests,
}:

assert enableCgiScripts -> gd != null;

stdenv.mkDerivation rec {
  pname = "apcupsd";
  version = "3.14.14";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0rwqiyzlg9p0szf3x6q1ppvrw6f6dbpn2rc5z623fk3bkdalhxyv";
  };

  nativeBuildInputs = [
    pkg-config
    man
    unixtools.col
  ];

  buildInputs =
    lib.optional enableCgiScripts gd
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libusb-compat-0_1
    ];

  prePatch = ''
    sed -e "s,\$(INSTALL_PROGRAM) \$(STRIP),\$(INSTALL_PROGRAM)," \
        -i ./src/apcagent/Makefile ./autoconf/targets.mak
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/apcagent/Makefile \
      --replace-fail "Applications" "$out/Applications"
    substituteInPlace include/libusb.h.in \
      --replace-fail "@LIBUSBH@" "${libusb-compat-0_1.dev}/include/usb.h"
    substituteInPlace platforms/darwin/Makefile \
      --replace-fail "/Library/LaunchDaemons" "$out/Library/LaunchDaemons" \
      --replace-fail "/System/Library/Extensions" "$out/System/Library/Extensions"
  '';

  preConfigure = ''
    sed -i 's|/bin/cat|${coreutils}/bin/cat|' configure
  '';

  # ./configure ignores --prefix, so we must specify some paths manually
  # There is no real reason for a bin/sbin split, so just use bin.
  configureFlags = [
    "--bindir=${placeholder "out"}/bin"
    "--sbindir=${placeholder "out"}/bin"
    "--sysconfdir=${placeholder "out"}/etc/apcupsd"
    "--mandir=${placeholder "out"}/share/man"
    "--with-halpolicydir=${placeholder "out"}/share/halpolicy"
    "--localstatedir=/var"
    "--with-nologin=/run"
    "--with-log-dir=/var/log/apcupsd"
    "--with-pwrfail-dir=/run/apcupsd"
    "--with-lock-dir=/run/lock"
    "--with-pid-dir=/run"
    "--enable-usb"
    "ac_cv_path_WALL=${wall}/bin/wall"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "ac_cv_path_SHUTDOWN=${systemd}/sbin/shutdown"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "ac_cv_path_SHUTDOWN=/sbin/shutdown"
    "ac_cv_func_which_gethostbyname_r=no"
  ]
  ++ lib.optionals enableCgiScripts [
    "--enable-cgi"
    "--with-cgi-bin=${placeholder "out"}/libexec/cgi-bin"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    for file in "$out"/etc/apcupsd/*; do
        sed -i -e 's|^WALL=.*|WALL="${wall}/bin/wall"|g' \
               -e 's|^HOSTNAME=.*|HOSTNAME=`${hostname}/bin/hostname`|g' \
               "$file"
    done
    rm -f "$out/bin/apcupsd-uninstall"
  '';

  passthru.tests.smoke = nixosTests.apcupsd;

  meta = with lib; {
    description = "Daemon for controlling APC UPSes";
    homepage = "http://www.apcupsd.com/";
    license = licenses.gpl2Only;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
