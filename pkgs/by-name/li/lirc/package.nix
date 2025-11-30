{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  help2man,
  python3,
  linuxHeaders,

  alsa-lib,
  libxslt,
  systemd,
  libusb-compat-0_1,
  libftdi1,
  libICE,
  libSM,
  libX11,
}:

let
  pythonEnv = python3.pythonOnBuildForHost.withPackages (
    p: with p; [
      pyyaml
      setuptools
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "lirc";
  version = "0.10.2";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${pname}-${version}.tar.bz2";
    sha256 = "sha256-PUTsgnSIHPJi8WCAVkHwgn/8wgreDYXn5vO5Dg09Iio=";
  };

  patches = [
    # Fix installation of Python bindings
    (fetchpatch {
      url = "https://sourceforge.net/p/lirc/tickets/339/attachment/0001-Fix-Python-bindings.patch";
      sha256 = "088a39x8c1qd81qwvbiqd6crb2lk777wmrs8rdh1ga06lglyvbly";
    })

    # Add a workaround for linux-headers-5.18 until upstream adapts:
    #   https://sourceforge.net/p/lirc/git/merge-requests/45/
    ./linux-headers-5.18.patch

    # remove check for `Ubuntu` in /proc/version which will override
    # --with-systemdsystemunitdir
    # https://sourceforge.net/p/lirc/tickets/385/
    ./ubuntu.diff
  ];

  postPatch = ''
    patchShebangs .

    # fix overriding PYTHONPATH
    sed -i 's,^PYTHONPATH *= *,PYTHONPATH := $(PYTHONPATH):,' \
      Makefile.in
    sed -i 's,PYTHONPATH=,PYTHONPATH=$(PYTHONPATH):,' \
      doc/Makefile.in

    # Pull fix for new pyyaml pending upstream inclusion
    #   https://sourceforge.net/p/lirc/git/merge-requests/39/
    substituteInPlace python-pkg/lirc/database.py --replace 'yaml.load(' 'yaml.safe_load('

    # cant import '/build/lirc-0.10.1/python-pkg/lirc/_client.so' while cross-compiling to check the version
    substituteInPlace python-pkg/setup.py \
      --replace "VERSION='0.0.0'" "VERSION='${version}'"
  '';

  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    help2man
    libxslt
    pythonEnv
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    systemd
    libusb-compat-0_1
    libftdi1
    libICE
    libSM
    libX11
  ];

  DEVINPUT_HEADER = "${linuxHeaders}/include/linux/input-event-codes.h";

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--enable-uinput" # explicit activation because build env has no uinput
    "--enable-devinput" # explicit activation because build env has no /dev/input
    "--with-lockdir=/run/lirc/lock" # /run/lock is not writable for 'lirc' user
    "PYTHON=${pythonEnv.interpreter}"
  ];

  installFlags = [
    "sysconfdir=$out/etc"
    "localstatedir=$TMPDIR"
  ];

  # Upstream ships broken symlinks in docs
  dontCheckForBrokenSymlinks = true;

  meta = with lib; {
    description = "Allows to receive and send infrared signals";
    homepage = "https://www.lirc.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
