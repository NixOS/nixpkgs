{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cups,
  dejavu_fonts,
  dbus,
  freetype,
  fontconfig,
  ghostscript,
  lcms2,
  libexif,
  libjpeg,
  libpng,
  libtiff,
  pkg-config,
  poppler_utils,
  mupdf,
  poppler,
  qpdf,
  withAvahi ? true,
  avahi,
}:

stdenv.mkDerivation rec {
  pname = "libcupsfilters";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libcupsfilters";
    rev = version;
    hash = "sha256-yUhVwEOEsTGV/zFES1fhNUWX5AQDIDNJE2BvlWFK4QU=";
  };

  patches =
    [
      # Patch upstream syntax error when !HAVE_OPEN_MEMSTREAM (on darwin)
      ./libcupsfilters-syntax-error.patch
    ]
    ++ lib.optionals (stdenv.hostPlatform.libc != "glibc") [
      # execvpe is a GNU extension
      ./libcupsfilters-darwin-execvpe.patch
    ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cups
    libexif
    libjpeg
    libpng
    libtiff
    lcms2
    freetype
    fontconfig
    qpdf
    poppler
    dbus
    ghostscript
    mupdf # used for mutool
  ] ++ lib.optionals withAvahi [ avahi ];

  configureFlags = [
    "--with-mutool-path=${lib.getBin mupdf}/bin/mutool"
    "--with-gs-path=${lib.getExe ghostscript}"
    "--with-ippfind-path=${lib.getBin cups}/bin/ippfind"
    "--with-shell=${stdenv.shell}"
    "--with-test-font-path=${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ] ++ lib.optionals (!withAvahi) [ "--disable-avahi" ];

  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];

  postConfigure = ''
    # Ensure that bannertopdf can find the PDF templates in $out.
    # By default, it assumes that cups and cups-filters are installed in the same prefix.
    substituteInPlace config.h \
      --replace-fail ${cups.out}/share/cups/data $out/share/cups/data
  '';

  doCheck = true;

  meta = {
    description = "Support library for filter functions";
    homepage = "https://github.com/OpenPrinting/libcupsfilters";
    changelog = "https://github.com/OpenPrinting/libcupsfilters/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tmarkus ];
    platforms = lib.platforms.unix;
  };
}
