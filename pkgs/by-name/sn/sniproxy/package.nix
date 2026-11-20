{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  c-ares,
  curl,
  libbsd,
  libev,
  libseccomp,
  openssl,
  pcre2,
  perl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sniproxy";
  version = "0.26.0";

  # Upstream dlundquist/sniproxy stopped releasing at 0.7.0.
  # That version is vulnerable CVE-2026-119760.
  # The fork is the maintained version. It contains additional hardening and
  # better dependencies.
  src = fetchFromGitHub {
    owner = "renaudallard";
    repo = "sniproxy";
    tag = finalAttrs.version;
    hash = "sha256-Ze4TuWU7u6EkuW4CxTpxm1IsND4aEZh7sztu7hnLvwk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    c-ares
    libbsd
    libev
    libseccomp
    openssl
    pcre2
  ];

  postPatch = ''
    patchShebangs tests
  '';

  nativeCheckInputs = [
    curl
    perl
  ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/renaudallard/sniproxy";
    description = "Transparent TLS and HTTP layer 4 proxy with SNI support";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      womfoo
      raitobezarius
    ];
    platforms = lib.platforms.linux;
    mainProgram = "sniproxy";
  };
})
