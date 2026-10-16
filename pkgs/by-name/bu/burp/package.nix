{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  acl,
  librsync,
  ncurses,
  openssl,
  zlib,
  uthash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "burp";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    tag = finalAttrs.version;
    hash = "sha256-jZSrHq3dL9Za71E2k4UDTHe10ESAgkBy5bogY2AqtnM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    librsync
    ncurses
    openssl
    zlib
    uthash
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) acl;

  configureFlags = [
    "--sysconfdir=/etc/burp"
    "--localstatedir=/var"
  ];

  installFlags = [ "localstatedir=/tmp" ];

  meta = {
    description = "Backup and restore Program";
    homepage = "https://burp.grke.org";
    changelog = "https://github.com/grke/burp/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ arjan-s ];
    platforms = lib.platforms.all;
  };
})
