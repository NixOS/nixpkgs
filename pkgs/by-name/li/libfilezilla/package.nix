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
  version = "0.56.1";

  src = fetchurl {
    # Upstream download link was made unstable on purpose
    # See https://trac.filezilla-project.org/ticket/13186
    url = "https://sources.archlinux.org/other/libfilezilla/libfilezilla-${finalAttrs.version}.tar.xz";
    hash = "sha256-rL8r36LFpLHy/zaCs9UsuaZUIv1fPh+WR9iEahB7cck=";
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
