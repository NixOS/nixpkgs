{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  cppunit,
  directoryListingUpdater,
  gettext,
  gnutls,
  nettle,
  pkg-config,
  libiconv,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfilezilla";
  version = "0.58.0";
  __structuredAttrs = true;

  src = fetchurl {
    # Upstream download link was made unstable on purpose
    # See https://trac.filezilla-project.org/ticket/13186
    url = "https://sources.archlinux.org/other/libfilezilla/libfilezilla-${finalAttrs.version}.tar.xz";
    hash = "sha256-J216cgr1Opdn3kiCvZkplsVDCwsTvgWRO9emQAUtbs4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gettext
    gnutls
    nettle
    libxcrypt
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  doCheck = true;

  checkInputs = [ cppunit ];

  # string_test::test_conversion2 converts non-ASCII text through the
  # locale charset and fails in the C locale
  preCheck = ''
    export LC_ALL=C.UTF-8
  '';

  # socket_test connects over loopback
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = directoryListingUpdater { };

  meta = {
    homepage = "https://lib.filezilla-project.org/";
    description = "Modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      iedame
      pSub
    ];
    platforms = lib.platforms.unix;
  };
})
