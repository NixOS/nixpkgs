{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  doxygen,
  libxslt,
  pkg-config,
  pcsclite,
  libtool,
  libusb-compat-0_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openct";
  version = "0.6.20";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "openct";
    rev = "openct-${finalAttrs.version}";
    hash = "sha256-YloE4YsvvYwfwmMCsEMGctApO/ujyZP/iAz21iXAnSc=";
  };

  postPatch = ''
    substituteInPlace etc/Makefile.am \
      --replace-fail "DESTDIR" "out"
  '';

  # unbreak build on GCC 14, remove when https://github.com/OpenSC/openct/pull/12
  # (or equivalent) is merged and released
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  configureFlags = [
    "--enable-api-doc"
    "--enable-usb"
    "--enable-pcsc"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    libxslt # xsltproc
    pkg-config
  ];

  buildInputs = [
    pcsclite
    libtool # libltdl
    libusb-compat-0_1
  ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $out/etc
  '';

  meta = {
    homepage = "https://github.com/OpenSC/openct/";
    description = "Drivers for several smart card readers";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
