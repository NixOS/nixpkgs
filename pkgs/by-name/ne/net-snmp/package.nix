{
  lib,
  stdenv,
  fetchurl,
  file,
  openssl,
  perl,
  net-tools,
  autoreconfHook,
  withPerlTools ? false,
}:
let

  perlWithPkgs = perl.withPackages (
    ps: with ps; [
      JSON
      TermReadKey
      Tk
    ]
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "net-snmp";
  version = "5.9.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/net-snmp-${finalAttrs.version}.tar.gz";
    hash = "sha256-FnB3GfgzGEpLcoNdrDWa4YgSOwa15CgXwAeQ19wThL8=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "lib"
  ];

  configureFlags = [
    "--with-default-snmp-version=3"
    "--with-sys-location=Unknown"
    "--with-sys-contact=root@unknown"
    "--with-logfile=/var/log/net-snmpd.log"
    "--with-persistent-directory=/var/lib/net-snmp"
    "--with-openssl=${openssl.dev}"
    "--disable-embedded-perl"
    "--without-perl-modules"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "--with-mnttab=/proc/mounts";

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      # https://github.com/net-snmp/net-snmp/pull/1053
      "-Wno-declaration-after-statement"
    ]
  );

  postPatch = ''
    substituteInPlace testing/fulltests/support/simple_TESTCONF.sh --replace-fail "/bin/netstat" "${net-tools}/bin/netstat"
  '';

  postConfigure = ''
    # libraries contain configure options. Mangle store paths out from
    # ./configure-generated file.
    sed -i include/net-snmp/net-snmp-config.h \
      -e "/NETSNMP_CONFIGURE_OPTIONS/ s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g"
  '';

  nativeBuildInputs = [
    net-tools
    file
    autoreconfHook
  ];
  buildInputs = [ openssl ] ++ lib.optional withPerlTools perlWithPkgs;

  enableParallelBuilding = true;
  # Missing dependencies during relinking:
  #   ./.libs/libnetsnmpagent.so: file not recognized: file format not recognized
  enableParallelInstalling = false;
  doCheck = false; # tries to use networking

  postInstall = ''
    for f in "$lib/lib/"*.la $bin/bin/net-snmp-config $bin/bin/net-snmp-create-v3-user; do
      sed 's|-L${openssl.dev}|-L${lib.getLib openssl}|g' -i $f
    done
    mkdir $dev/bin
    mv $bin/bin/net-snmp-config $dev/bin
  '';

  meta = {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = "https://www.net-snmp.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    changelog = "https://github.com/net-snmp/net-snmp/blob/v${finalAttrs.version}/NEWS";
  };
})
