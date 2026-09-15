{
  lib,
  stdenv,
  autoconf,
  automake,
  fetchFromGitHub,
  libgcrypt,
  libpcap,
  ncurses,
  openssl,
  pcre2,
  pkg-config,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sngrep";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "irontec";
    repo = "sngrep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tKIyU8W6Jvp0hoegCpOOIsJkMfEEtmfv9Se7VIQ7hVo=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];

  buildInputs = [
    libgcrypt
    libpcap
    ncurses
    openssl
    pcre2
  ];

  configureFlags = [
    "--with-pcre2"
    "--enable-unicode"
    "--enable-ipv6"
    "--enable-eep"
    "--with-openssl"
  ];

  patches = [
    # TODO: Remove this patch when updating to version 1.8.5
    (fetchpatch {
      name = "CVE-2026-90558.patch";
      url = "https://github.com/irontec/sngrep/commit/1ff74ee3ab5ff280e8ba976aa8c744dca57eb35b.patch";
      hash = "sha256-QizEvKztbosj3GoRtG9yxeqTglyBNLuuOmPF92XU7BE=";
    })

    ./fix-sng_strncpy-declaration.patch
  ];

  preConfigure = ''
    ./bootstrap.sh
  '';

  doCheck = true;

  meta = {
    description = "Tool for displaying SIP calls message flows from terminal";
    mainProgram = "sngrep";
    homepage = "https://github.com/irontec/sngrep";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jorise ];
  };
})
