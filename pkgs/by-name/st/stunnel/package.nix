{
  fetchurl,
  lib,
  nixosTests,
  openssl,
  stdenv,
  systemd,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  mimalloc,
  mimallocSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stunnel";
  version = "5.75";

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchurl {
    url = "https://www.stunnel.org/archive/${lib.versions.major finalAttrs.version}.x/stunnel-${finalAttrs.version}.tar.gz";
    hash = "sha256-DB7w7YUkCXTcy5T+dPuS1jg0dMfA0Q6HltH3gaO6VoM=";
    # please use the contents of "https://www.stunnel.org/downloads/stunnel-${version}.tar.gz.sha256",
    # not the output of `nix-prefetch-url`
  };

  enableParallelBuilding = true;

  buildInputs = [
    openssl
  ]
  ++ lib.optionals systemdSupport [
    systemd
  ]
  ++ lib.optionals mimallocSupport [
    mimalloc
  ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (lib.enableFeature systemdSupport "systemd")
  ];

  postInstall = ''
    # remove legacy compatibility-wrapper that would require perl
    rm $out/bin/stunnel3
  '';

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  passthru.tests = {
    stunnel = nixosTests.stunnel;
  };

  meta = {
    description = "Universal tls/ssl wrapper";
    homepage = "https://www.stunnel.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.thoughtpolice ];
    platforms = lib.platforms.unix;
    mainProgram = "stunnel";
  };
})
