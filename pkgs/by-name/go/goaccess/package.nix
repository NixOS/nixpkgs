{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  gettext,
  libmaxminddb,
  ncurses,
  openssl,
  withGeolocation ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goaccess";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "allinurl";
    repo = "goaccess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hLabLVnLCCIAuQbzUxiPomLzFXGk65Ea+COdDqPW0pM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    ncurses
    openssl
  ]
  ++ lib.optionals withGeolocation [ libmaxminddb ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ gettext ];

  configureFlags = [
    "--enable-utf8"
    "--with-openssl"
  ]
  ++ lib.optionals withGeolocation [ "--enable-geoip=mmdb" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-DHOST_NAME_MAX=_POSIX_HOST_NAME_MAX"
    ]
  );

  meta = {
    description = "Real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems";
    homepage = "https://goaccess.io";
    changelog = "https://github.com/allinurl/goaccess/raw/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ederoyd46 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "goaccess";
  };
})
