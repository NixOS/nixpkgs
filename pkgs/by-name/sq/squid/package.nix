{
  lib,
  stdenv,
  fetchurl,
  perl,
  openldap,
  pam,
  db,
  cyrus_sasl,
  libcap,
  expat,
  libxml2,
  openssl,
  pkg-config,
  systemd,
  cppunit,
  ipv6 ? true,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "squid";
  version = "7.0.1";

  src = fetchurl {
    url = "https://github.com/squid-cache/squid/releases/download/SQUID_${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }/squid-${finalAttrs.version}.tar.xz";
    hash = "sha256-Bw3Y5iGtItRdcAYF6xnSysG2zae3PwTzRXjTw/2N35s=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      perl
      openldap
      db
      cyrus_sasl
      expat
      libxml2
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libcap
      pam
      systemd
    ];

  enableParallelBuilding = true;

  configureFlags =
    [
      "--disable-strict-error-checking"
      "--disable-arch-native"
      "--with-openssl"
      "--enable-ssl-crtd"
      "--enable-storeio=ufs,aufs,diskd,rock"
      "--enable-removal-policies=lru,heap"
      "--enable-delay-pools"
      "--enable-x-accelerator-vary"
      "--enable-htcp"
    ]
    ++ (if ipv6 then [ "--enable-ipv6" ] else [ "--disable-ipv6" ])
    ++ lib.optional (
      stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isMusl
    ) "--enable-linux-netfilter";

  doCheck = true;
  nativeCheckInputs = [ cppunit ];
  preCheck = ''
    # tests attempt to copy around "/bin/true" to make some things
    # no-ops but this doesn't work if our "true" is a multi-call
    # binary, so make our own fake "true" which will work when used
    # this way
    echo "#!$SHELL" > fake-true
    chmod +x fake-true
    grep -rlF '/bin/true' test-suite/ | while read -r filename ; do
      substituteInPlace "$filename" \
        --replace "$(type -P true)" "$(realpath fake-true)" \
        --replace "/bin/true" "$(realpath fake-true)"
    done

    cd test-suite/
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/libexec $out/etc $out/share
    cd ..
    cp src/squid $out/bin
    cp src/unlinkd $out/libexec
    cp src/mime.conf.default $out/etc/mime.conf
    cp -r icons $out/share
    cp -r errors $out/share
    runHook postInstall
  '';

  passthru.tests.squid = nixosTests.squid;

  meta = with lib; {
    description = "Caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = "http://www.squid-cache.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
    knownVulnerabilities = [
      "Squid has multiple unresolved security vulnerabilities, for more information see https://megamansec.github.io/Squid-Security-Audit/"
    ];
  };
})
