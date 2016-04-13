{ stdenv, fetchurl
, avahi, libjpeg, libusb1, libv4l, net_snmp
, gettext, pkgconfig

# List of { src name backend } attibute sets - see installFirmware below:
, extraFirmware ? []

# For backwards compatibility with older setups; use extraFirmware instead:
, gt68xxFirmware ? null, snapscanFirmware ? null

# Passed from versioned package (e.g. default.nix, git.nix):
, version, src, ...
}:

stdenv.mkDerivation {
  inherit src version;

  name = "sane-backends-${version}";

  outputs = [ "out" "doc" "man" ];

  configureFlags = []
    ++ stdenv.lib.optional (avahi != null) "--enable-avahi"
    ++ stdenv.lib.optional (libusb1 != null) "--enable-libusb_1_0"
    ;

  buildInputs = [ avahi libusb1 libv4l net_snmp ];
  nativeBuildInputs = [ gettext pkgconfig ];

  postInstall = let

    compatFirmware = extraFirmware
      ++ stdenv.lib.optional (gt68xxFirmware != null) {
        src = gt68xxFirmware.fw;
        inherit (gt68xxFirmware) name;
        backend = "gt68xx";
      }
      ++ stdenv.lib.optional (snapscanFirmware != null) {
        src = snapscanFirmware;
        name = "your-firmwarefile.bin";
        backend = "snapscan";
      };

    installFirmware = f: ''
      mkdir -p $out/share/sane/${f.backend}
      ln -sv ${f.src} $out/share/sane/${f.backend}/${f.name}
    '';

  in ''
    mkdir -p $out/etc/udev/rules.d/
    ./tools/sane-desc -m udev > $out/etc/udev/rules.d/49-libsane.rules || \
    cp tools/udev/libsane.rules $out/etc/udev/rules.d/49-libsane.rules
    # the created 49-libsane references /bin/sh
    substituteInPlace $out/etc/udev/rules.d/49-libsane.rules \
      --replace "RUN+=\"/bin/sh" "RUN+=\"${stdenv.shell}"

    substituteInPlace $out/lib/libsane.la \
      --replace "-ljpeg" "-L${libjpeg}/lib -ljpeg"
  '' + stdenv.lib.concatStrings (builtins.map installFirmware compatFirmware);

  meta = with stdenv.lib; {
    description = "SANE (Scanner Access Now Easy) backends";
    longDescription = ''
      Collection of open-source SANE backends (device drivers).
      SANE is a universal scanner interface providing standardized access to
      any raster image scanner hardware: flatbed scanners, hand-held scanners,
      video- and still-cameras, frame-grabbers, etc. For a list of supported
      scanners, see http://www.sane-project.org/sane-backends.html.
    '';
    homepage = "http://www.sane-project.org/";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ nckx simons ];
    platforms = platforms.linux;
  };
}
