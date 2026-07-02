{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gettext,
  gnutls,
  nettle,
  pkg-config,
  libiconv,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfilezilla";
  version = "0.55.5";

  src = fetchurl {
    # Upstream download link was made unstable on purpose
    # See https://trac.filezilla-project.org/ticket/13186
    url = "https://sources.archlinux.org/other/libfilezilla/libfilezilla-${finalAttrs.version}.tar.xz";
    hash = "sha256-SQwDLvB8WOurdpe3xRAk3XceovgPxM3JKQjDSDV+BT4=";
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

  enableParallelBuilding = true;

  meta = {
    homepage = "https://lib.filezilla-project.org/";
    description = "Modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      iedame
      pSub
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
