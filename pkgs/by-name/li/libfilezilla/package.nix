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
  version = "0.49.0";

  src = fetchsvn {
    url = "https://svn.filezilla-project.org/svn/libfilezilla/trunk";
    rev = "11192";
    hash = "sha256-fm1cenGwYcPz0TtMzbPXrZA7nAzwo8toBNA9cW2Gnh0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    [
      gettext
      gnutls
      nettle
      libxcrypt
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://lib.filezilla-project.org/";
    description = "Modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
