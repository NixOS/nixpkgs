{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config
, acl, librsync, ncurses, openssl_legacy, zlib, uthash }:

stdenv.mkDerivation rec {
  pname = "burp";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    rev = version;
    sha256 = "sha256-y6kRd1jD6t+Q6d5t7W9MDuk+m2Iq1THQkP50PJwI7Nc=";
  };

  patches = [
    # Pull upstream fix for ncurses-6.3 support
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/grke/burp/commit/1d6c931af7c11f164cf7ad3479781e8f03413496.patch";
      sha256 = "14sfbfahlankz3xg6v10i8fnmpnmqpp73q9xm0l0hnjh25igv6bl";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  # use openssl_legacy due to burp-2.4.0 not supporting file encryption with openssl 3.0
  # replace with 'openssl' once burp-3.x has been declared stable and this package upgraded
  buildInputs = [ librsync ncurses openssl_legacy zlib uthash ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) acl;

  configureFlags = [ "--localstatedir=/var" ];

  installFlags = [ "localstatedir=/tmp" ];

  meta = with lib; {
    description = "BURP - BackUp and Restore Program";
    homepage    = "https://burp.grke.org";
    license     = licenses.agpl3Plus;
    maintainers = with maintainers; [ arjan-s ];
    platforms   = platforms.all;
  };
}
