{
  lib,
  bmake,
  fetchurl,
  groff,
  inetutils,
  libxcrypt,
  lua,
  openssl,
  stdenv,
  wget,
  # Boolean flags
  minimal ? false,
  userSupport ? !minimal,
  cgiSupport ? !minimal,
  dirIndexSupport ? !minimal,
  dynamicContentSupport ? !minimal,
  sslSupport ? !minimal,
  luaSupport ? !minimal,
  htpasswdSupport ? !minimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bozohttpd";
  version = "20240126";

  # bozohttpd is developed in-tree in pkgsrc, canonical hashes can be found at:
  # http://cvsweb.netbsd.org/bsdweb.cgi/pkgsrc/www/bozohttpd/distinfo
  src = fetchurl {
    url = "http://eterna23.net/bozohttpd/bozohttpd-${finalAttrs.version}.tar.bz2";
    hash = "sha512-fr1PnyYAS3wkpmj/npRC3A87UL9LIXw4thlM4GfrtlJbuX5EkWGVJnHJW/EmYp7z+N91dcdRJgdO79l6WJsKpg==";
  };

  buildInputs = [
    libxcrypt
    openssl
  ]
  ++ lib.optionals luaSupport [ lua ];

  nativeBuildInputs = [
    bmake
    groff
  ];

  nativeCheckInputs = [
    inetutils
    wget
  ];

  env = {
    COPTS = lib.concatStringsSep " " (
      [
        "-D_DEFAULT_SOURCE"
        "-D_GNU_SOURCE"

        # ensure that we can serve >2GB files even on 32-bit systems.
        "-D_LARGEFILE_SOURCE"
        "-D_FILE_OFFSET_BITS=64"

        # unpackaged dependency: https://man.netbsd.org/blocklist.3
        "-DNO_BLOCKLIST_SUPPORT"
      ]
      ++ lib.optionals htpasswdSupport [ "-DDO_HTPASSWD" ]
      ++ lib.optionals (!cgiSupport) [ "-DNO_CGIBIN_SUPPORT" ]
      ++ lib.optionals (!dirIndexSupport) [ "-DNO_DIRINDEX_SUPPORT" ]
      ++ lib.optionals (!dynamicContentSupport) [ "-DNO_DYNAMIC_CONTENT" ]
      ++ lib.optionals (!luaSupport) [ "-DNO_LUA_SUPPORT" ]
      ++ lib.optionals (!sslSupport) [ "-DNO_SSL_SUPPORT" ]
      ++ lib.optionals (!userSupport) [ "-DNO_USER_SUPPORT" ]
    );

    _LDADD = lib.concatStringsSep " " (
      [ "-lm" ]
      ++ lib.optionals (stdenv.hostPlatform.libc != "libSystem") [ "-lcrypt" ]
      ++ lib.optionals luaSupport [ "-llua" ]
      ++ lib.optionals sslSupport [
        "-lcrypto"
        "-lssl"
      ]
    );
  };

  makeFlags = [ "LDADD=$(_LDADD)" ];

  checkFlags = lib.optionals (!cgiSupport) [ "CGITESTS=" ];

  doCheck = true;

  meta = {
    homepage = "http://www.eterna23.net/bozohttpd/";
    description = "Bozotic HTTP server; small and secure";
    longDescription = ''
      bozohttpd is a small and secure HTTP version 1.1 server. Its main
      feature is the lack of features, reducing the code size and improving
      verifiability.

      It supports CGI/1.1, HTTP/1.1, HTTP/1.0, HTTP/0.9, ~user translations,
      virtual hosting support, as well as multiple IP-based servers on a
      single machine. It is capable of servicing pages via the IPv6 protocol.
      It has SSL support. It has no configuration file by design.
    '';
    changelog = "http://www.eterna23.net/bozohttpd/CHANGES";
    license = lib.licenses.bsd2;
    mainProgram = "bozohttpd";
    maintainers = [ lib.maintainers.embr ];
    platforms = lib.platforms.all;
  };
})
