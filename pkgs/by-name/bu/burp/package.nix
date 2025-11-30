{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  acl,
  librsync,
  ncurses,
  openssl_legacy,
  zlib,
  uthash,
}:

stdenv.mkDerivation rec {
  pname = "burp";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    tag = version;
    hash = "sha256-y6kRd1jD6t+Q6d5t7W9MDuk+m2Iq1THQkP50PJwI7Nc=";
  };

  patches = [
    # Pull upstream fix for ncurses-6.3 support
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/grke/burp/commit/1d6c931af7c11f164cf7ad3479781e8f03413496.patch";
      hash = "sha256-dJn9YhFQWggoqD3hce7F1d5qHYogbPP6+NMqCpVbTpM=";
    })
    # Pull upstream fix for backup resuming
    (fetchpatch {
      name = "fix-resume.patch";
      url = "https://github.com/grke/burp/commit/b5ed667f73805b5af9842bb0351f5af95d4d50b3.patch";
      hash = "sha256-MT9D2thLgV4nT3LsIDHZp8sWQF2GlOENj0nkOQXZKuk=";
    })
  ];

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
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) acl;

  configureFlags = [ "--localstatedir=/var" ];

  installFlags = [ "localstatedir=/tmp" ];

  meta = with lib; {
    description = "BackUp and Restore Program";
    homepage = "https://burp.grke.org";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ arjan-s ];
    platforms = platforms.all;
  };
}
