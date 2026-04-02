{
  lib,
  stdenv,
  fetchsvn,
  autoreconfHook,
  gettext,
  gnutls,
  nettle,
  pkg-config,
  libiconv,
  libxcrypt,
}:

stdenv.mkDerivation {
  pname = "libfilezilla";
  version = "0.54.1";

  src = fetchsvn {
    url = "https://svn.filezilla-project.org/svn/libfilezilla/trunk";
    rev = "11363";
    hash = "sha256-m4CfnovtZPvwwjlyWKx/L1OkjiIlKfR7tqg+xB+nqzw=";
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
}
