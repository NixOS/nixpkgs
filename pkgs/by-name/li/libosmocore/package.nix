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
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = finalAttrs.version;
    hash = "sha256-4ORHDU0ARLPzUss9Nfx3CO9D96sSZbFKArqndxtFJQc=";
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
