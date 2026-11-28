{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  zlib,
  gnutls,
  avahi,
  libpng,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcups3";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "nick-linux8";
    repo = "libcups";
    rev = "09d7031cb04d2a950619b63959a4db95623bb63f";
    # PDFio is a required git submodule; upstream explicitly documents the
    # GitHub zip archive as broken because it omits it.
    fetchSubmodules = true;
    hash = "sha256-S6V7QeEuTBGsH2g9tmKTb6hBr1Tnf6L9gp3kgJ1ZZPM=";
  };

  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];

  # Without this, the generic builder's default --sysconfdir=$out/etc gets
  # compiled into CUPS_SERVERROOT, so client.conf lookups resolve to an
  # immutable store path instead of the real /etc/cups - meaning no
  # libcups3-linked app (Firefox, GTK print dialogs, etc.) can ever be
  # pointed at the cups-local socket via client.conf.
  configureFlags = [ "--sysconfdir=/etc" ];

  buildInputs = [
    zlib.dev
    gnutls
    avahi
    libpng.dev
  ]
  ++ lib.optional (!stdenv.hostPlatform.isLinux) libiconv;

  strictDeps = true;

  env = {
    NIX_LDFLAGS = "-lpng16";
  };

  postPatch = ''
    sed -i '/test -x \/usr\/sbin\/ldconfig/d' cups/Makefile
  '';

  postConfigure = ''
    if [ -f pdfio/pdfio.pc ]; then
      sed -i '/^Requires.*libpng/d; /^Requires.*zlib/d' pdfio/pdfio.pc
    fi
  '';

  meta = {
    description = "OpenPrinting CUPS 3.x library and IPP/HTTP client tools";
    homepage = "https://github.com/OpenPrinting/libcups";
    changelog = "https://github.com/OpenPrinting/libcups/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.unix;
  };
})
