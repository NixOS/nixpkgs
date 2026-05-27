{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "2.11.0-Beta2";

  src = fetchFromGitHub {
    owner = "trusteddomainproject";
    repo = "OpenDKIM";
    tag = "rel-opendkim-${lib.replaceString "." "-" finalAttrs.version}";
    hash = "sha256-/IqWB0s39t8BeqpRIa8MZn4HgXlIMuU2UbYbpZGNo1s=";
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
      "--version=unstable"
      "--version-regex=rel-opendkim-(\\d+)-(\\d+)-(.*)"
    ];
  };

  meta = {
    description = "C library for producing DKIM-aware applications and an open source milter for providing DKIM service";
    homepage = "http://www.opendkim.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "opendkim";
    knownVulnerabilities = [
      "CVE-2020-35766: Privilege escalation in test suite"
      "CVE-2022-48521: Specially crafted e-mails can bypass DKIM signature validation"
      "Upstream OpenDKIM hasn't been updated in years, and is assumed to be unmaintained. Consider using an alternative such as rspamd."
    ];
    maintainers = with lib.maintainers; [ maevii ];
  };
})
