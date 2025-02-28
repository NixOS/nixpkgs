{
  lib,
  stdenv,
  fetchurl,
  libpcap,
  bison,
  flex,
  cyrus_sasl,
  tcp_wrappers,
  pkg-config,
  procps,
  which,
  wget,
  lsof,
  net-snmp,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "argus";
  version = "3.0.8.2";

  src = fetchurl {
    url = "http://qosient.com/argus/src/${pname}-${version}.tar.gz";
    sha256 = "1zzf688dbbcb5z2r9v1p28rddns6znzx35nc05ygza6lp7aknkna";
  };

  nativeBuildInputs = [
    pkg-config
    bison
    flex
  ];
  buildInputs = [
    libpcap
    cyrus_sasl
    tcp_wrappers
  ];
  propagatedBuildInputs = [
    procps
    which
    wget
    lsof
    net-snmp
  ];

  patchPhase = ''
     substituteInPlace events/argus-extip.pl \
       --subst-var-by PERLBIN ${perl}/bin/perl
    substituteInPlace events/argus-lsof.pl \
      --replace "\`which lsof\`" "\"${lsof}/bin/lsof\"" \
      --subst-var-by PERLBIN ${perl}/bin/perl
    substituteInPlace events/argus-vmstat.sh \
      --replace vm_stat ${procps}/bin/vmstat
    substituteInPlace events/argus-snmp.sh \
      --replace /usr/bin/snmpget ${lib.getBin net-snmp}/bin/snmpget \
      --replace /usr/bin/snmpwalk ${lib.getBin net-snmp}/bin/snmpwalk
  '';

  meta = with lib; {
    description = "Audit Record Generation and Utilization System for networks";
    longDescription = ''
      The Argus Project is focused on developing all
      aspects of large scale network situtational awareness derived from
      network activity audit. Argus, itself, is next-generation network
      flow technology, processing packets, either on the wire or in
      captures, into advanced network flow data. The data, its models,
      formats, and attributes are designed to support Network
      Operations, Performance and Security Management. If you need to
      know what is going on in your network, right now or historically,
      you will find Argus a useful tool.
    '';
    homepage = "http://qosient.com/argus";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
  };
}
