{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  acl,
  librsync,
  ncurses,
  openssl_legacy,
  zlib,
  uthash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "burp";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    tag = finalAttrs.version;
    hash = "sha256-/vYon0XUIuMAaaaRNehzMspKMHWp0tJm8JubRt1KmZU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # use openssl_legacy due to burp-2.4.0 not supporting file encryption with openssl 3.0
  # replace with 'openssl' once burp-3.x has been declared stable and this package upgraded
  buildInputs = [
    librsync
    ncurses
    openssl_legacy
    zlib
    uthash
  ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) acl;

  configureFlags = [
    "--sysconfdir=/etc/burp"
    "--localstatedir=/var"
  ];

  installFlags = [ "localstatedir=/tmp" ];

  meta = {
    description = "BURP - BackUp and Restore Program";
    homepage = "https://burp.grke.org";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ arjan-s ];
    platforms = lib.platforms.all;
  };
})
