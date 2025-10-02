{
  lib,
  stdenv,
  fetchgit,
  zlib,
  gnutlsSupport ? false,
  gnutls,
  nettle,
  opensslSupport ? true,
  openssl,
}:

assert (gnutlsSupport || opensslSupport);

stdenv.mkDerivation {
  pname = "rtmpdump";
  version = "2.6";

  src = fetchgit {
    url = "git://git.ffmpeg.org/rtmpdump";
    # Releases are not tagged.
    rev = "6f6bb1353fc84f4cc37138baa99f586750028a01";
    hash = "sha256-rwMA9eougKnkpG+fe6vZIwOBt2CC1d9qI9a079EbE5o=";
  };

  preBuild = ''
    makeFlagsArray+=(CC="$CC")
  '';

  makeFlags = [
    "prefix=$(out)"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ]
  ++ lib.optional gnutlsSupport "CRYPTO=GNUTLS"
  ++ lib.optional opensslSupport "CRYPTO=OPENSSL"
  ++ lib.optional stdenv.hostPlatform.isDarwin "SYS=darwin";

  propagatedBuildInputs = [
    zlib
  ]
  ++ lib.optionals gnutlsSupport [
    gnutls
    nettle
  ]
  ++ lib.optional opensslSupport openssl;

  outputs = [
    "out"
    "dev"
  ];

  separateDebugInfo = true;

  meta = with lib; {
    description = "Toolkit for RTMP streams";
    homepage = "https://rtmpdump.mplayerhq.hu/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
