{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  openssl,
  perl,
  pps-tools,
  libcap,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntp";
  version = "4.2.8p18";

  src = fetchurl {
    url = "https://archive.ntp.org/ntp4/ntp-${lib.versions.majorMinor finalAttrs.version}/ntp-${finalAttrs.version}.tar.gz";
    hash = "sha256-z4TF8/saKVKElCYk2CP/+mNBROCWz8T5lprJjvX0aOU=";
  };

  patches = [
    # Fix build w/ glibc-2.44
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/ntp/-/raw/8513bf75be3c0425318475e30f5725a03d8fb067/ntp-4.2.8.p18-glib-2.43.patch";
      hash = "sha256-20ztNAnirijKt8rgaMz6FGoHubBOskNL5ynXte3NTvM=";
    })
  ];

  # fix for gcc-14 compile failure
  postPatch = ''
    substituteInPlace sntp/m4/openldap-thread-check.m4 \
      --replace-fail "pthread_detach(NULL)" "pthread_detach(pthread_self())"
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openssl-libdir=${lib.getLib openssl}/lib"
    "--with-openssl-incdir=${openssl.dev}/include"
    "--enable-ignore-dns-errors"
    "--with-yielding-select=yes"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "--enable-linuxcaps";

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    openssl
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pps-tools
    libcap
  ];

  postInstall = ''
    rm -rf $out/share/doc
  '';

  meta = {
    homepage = "https://www.ntp.org/";
    description = "Implementation of the Network Time Protocol";
    license = lib.licenses.AND [
      lib.licenses.ntp
      lib.licenses.bsd2
    ];
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.unix;
  };
})
