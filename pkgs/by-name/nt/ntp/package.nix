{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  openssl,
  perl,
  pps-tools,
  libcap,
}:

stdenv.mkDerivation rec {
  pname = "ntp";
  version = "4.2.8p18";

  src = fetchurl {
    url = "https://archive.ntp.org/ntp4/ntp-${lib.versions.majorMinor version}/ntp-${version}.tar.gz";
    hash = "sha256-z4TF8/saKVKElCYk2CP/+mNBROCWz8T5lprJjvX0aOU=";
  };

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

  meta = with lib; {
    homepage = "https://www.ntp.org/";
    description = "Implementation of the Network Time Protocol";
    license = {
      # very close to isc and bsd2
      url = "https://www.eecis.udel.edu/~mills/ntp/html/copyright.html";
    };
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = platforms.unix;
  };
}
