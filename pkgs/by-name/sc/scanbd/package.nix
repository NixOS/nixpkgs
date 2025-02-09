{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  dbus,
  libconfuse,
  libjpeg,
  sane-backends,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "scanbd";
  version = "1.5.1";

  src = fetchurl {
    sha256 = "0pvy4qirfjdfm8aj6x5rkbgl7hk3jfa2s21qkk8ic5dqfjjab75n";
    url = "mirror://sourceforge/scanbd/${pname}-${version}.tgz";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libconfuse
    libjpeg
    sane-backends
    systemd
  ];

  configureFlags =
    [
      "--disable-Werror"
      "--enable-udev"
      "--with-scanbdconfdir=/etc/scanbd"
      "--with-systemdsystemunitdir=$out/lib/systemd/system"
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      # AC_FUNC_MALLOC is broken on cross builds.
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ];

  enableParallelBuilding = true;

  installFlags = [
    "scanbdconfdir=$(out)/etc/scanbd"
    "scannerconfdir=$(scanbdconfdir)/scanner.d"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Scanner button daemon";
    longDescription = ''
      scanbd polls a scanner's buttons, looking for button presses, function
      knob changes, or other scanner events such as paper inserts and removals,
      while at the same time allowing scan-applications to access the scanner.

      Various actions can be submitted (scan, copy, email, ...) via action
      scripts. The function knob values are passed to the action scripts as
      well. Scan actions are also signaled via dbus. This can be useful for
      foreign applications. Scans can also be triggered via dbus from foreign
      applications.

      On platforms which support signaling of dynamic device insertion/removal
      (libudev, dbus, hal), scanbd supports this as well.

      scanbd can use all sane-backends or some special backends from the (old)
      scanbuttond project.
    '';
    homepage = "http://scanbd.sourceforge.net/";
    downloadPage = "https://sourceforge.net/projects/scanbd/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
