{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  autoreconfHook,
  pkg-config,
  makeWrapper,
  libbsd,
  libmilter,
  openssl,
  perl,
  unbound,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opendkim";
  version = "2.11.0-Beta2-unstable-2026-06-06";

  src = fetchFromGitHub {
    owner = "trusteddomainproject";
    repo = "OpenDKIM";
    rev = "db15e09f57cf3e142bbfc1d6e984144077328ab8";
    hash = "sha256-kfV3Qf/ywIUI5c1zX9DVKqgBnJMtzp9HA+sJG29jLXM=";
  };

  configureFlags = [
    "--with-milter=${libmilter}"
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "--with-unbound=${unbound}";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libbsd
    openssl
    libmilter
    perl
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin unbound;

  postInstall = ''
    wrapProgram $out/sbin/opendkim-genkey \
      --prefix PATH : ${openssl.bin}/bin
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch=develop"
      "--version-regex=rel-opendkim-(\\d+)-(\\d+)-(.*)"
    ];
  };

  meta = {
    description = "C library for producing DKIM-aware applications and an open source milter for providing DKIM service";
    homepage = "http://www.opendkim.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "opendkim";
    maintainers = with lib.maintainers; [ maevii ];
  };
})
