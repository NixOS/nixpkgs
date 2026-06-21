{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  gnutls,
  libmnl,
  liburing,
  libusb1,
  lksctp-tools,
  pcsclite,
  pkg-config,
  python3,
  talloc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libosmocore";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = finalAttrs.version;
    hash = "sha256-C+fXc6T5k+Lokdr1m5DaFk+V2AP/GHI2Rzr2IAk4AZQ=";
  };

  postPatch = ''
    echo "${finalAttrs.version}" > .tarball-version
  '';

  propagatedBuildInputs = [
    talloc
    libmnl
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    gnutls
    liburing
    libusb1
    lksctp-tools
    pcsclite
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Set of Osmocom core libraries";
    homepage = "https://github.com/osmocom/libosmocore";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mog
    ];
  };
})
