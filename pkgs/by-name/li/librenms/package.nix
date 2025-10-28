{
  lib,
  fetchFromGitHub,
  fetchpatch,
  unixtools,
  php82,
  python3,
  makeWrapper,
  nixosTests,
  # run-time dependencies
  graphviz,
  ipmitool,
  libvirt,
  monitoring-plugins,
  mtr,
  net-snmp,
  nfdump,
  nmap,
  rrdtool,
  system-sendmail,
  whois,
  dataDir ? "/var/lib/librenms",
  logDir ? "/var/log/librenms",
}:

let
  phpPackage = php82.withExtensions ({ enabled, all }: enabled ++ [ all.memcached ]);
in
phpPackage.buildComposerProject2 rec {
  pname = "librenms";
  version = "25.4.0";

  src = fetchFromGitHub {
    owner = "librenms";
    repo = pname;
    tag = version;
    sha256 = "sha256-t+RupwKnUtQd3A0VzWhCXNzc+TnVnDMaMJ6Jcgp+Sfg=";
  };

  vendorHash = "sha256-t/3wBSXJJHqbGR1iKF4zC2Ia99gXNlanabR/iPPlHqw=";

  patches = [
    (fetchpatch {
      # https://github.com/advisories/GHSA-gq96-8w38-hhj2
      name = "CVE-2025-54138.patch";
      url = "https://github.com/librenms/librenms/commit/ec89714d929ef0cf2321957ed9198b0f18396c81.patch";
      hash = "sha256-UJy0AZXpvowvjSnJy7m4Z5JPoYWjydUg1R+jz/Pl1s0=";
    })
    (fetchpatch {
      # https://github.com/advisories/GHSA-frc6-pwgr-c28w
      name = "CVE-2025-62411.patch";
      url = "https://github.com/librenms/librenms/commit/706a77085f4d5964f7de9444208ef707e1f79450.patch";
      hash = "sha256-egltEZEg8yn+JCe/rlpxMuVMBbRgruIwR5y9aNwjrGg=";
    })
    (fetchpatch {
      # https://github.com/advisories/GHSA-6g2v-66ch-6xmh
      name = "CVE-2025-62412.patch";
      url = "https://github.com/librenms/librenms/commit/d9ec1d500b71b5ad268c71c0d1fde323da70c694.patch";
      hash = "sha256-DIE92KEegRoZNGSEr5VcbG0NQXNZbaKi0DeIBAyn608=";
    })
  ];

  php = phpPackage;

  buildInputs = [
    graphviz
    ipmitool
    libvirt
    monitoring-plugins
    mtr
    net-snmp
    nfdump
    nmap
    rrdtool
    system-sendmail
    unixtools.whereis
    whois
    (python3.withPackages (
      ps: with ps; [
        pymysql
        python-dotenv
        python-memcached
        redis
        setuptools
        psutil
        command-runner
      ]
    ))
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/librenms/* $out
    rm -r $out/share

    # This broken logic leads to bad settings being persisted in the database
    patch -p1 -d $out -i ${./broken-binary-paths.diff}

    substituteInPlace \
      $out/misc/config_definitions.json \
      --replace-fail '"default": "/bin/ping",' '"default": "/run/wrappers/bin/ping",' \
      --replace-fail '"default": "fping",' '"default": "/run/wrappers/bin/fping",' \
      --replace-fail '"default": "fping6",' '"default": "/run/wrappers/bin/fping6",' \
      --replace-fail '"default": "rrdtool",' '"default": "${rrdtool}/bin/rrdtool",' \
      --replace-fail '"default": "snmpgetnext",' '"default": "${net-snmp}/bin/snmpgetnext",' \
      --replace-fail '"default": "traceroute",' '"default": "/run/wrappers/bin/traceroute",' \
      --replace-fail '"default": "/usr/bin/dot",' '"default": "${graphviz}/bin/dot",' \
      --replace-fail '"default": "/usr/bin/ipmitool",' '"default": "${ipmitool}/bin/ipmitool",' \
      --replace-fail '"default": "/usr/bin/mtr",' '"default": "${mtr}/bin/mtr",' \
      --replace-fail '"default": "/usr/bin/nfdump",' '"default": "${nfdump}/bin/nfdump",' \
      --replace-fail '"default": "/usr/bin/nmap",' '"default": "${nmap}/bin/nmap",' \
      --replace-fail '"default": "/usr/bin/sfdp",' '"default": "${graphviz}/bin/sfdp",' \
      --replace-fail '"default": "/usr/bin/snmpbulkwalk",' '"default": "${net-snmp}/bin/snmpbulkwalk",' \
      --replace-fail '"default": "/usr/bin/snmpget",' '"default": "${net-snmp}/bin/snmpget",' \
      --replace-fail '"default": "/usr/bin/snmptranslate",' '"default": "${net-snmp}/bin/snmptranslate",' \
      --replace-fail '"default": "/usr/bin/snmpwalk",' '"default": "${net-snmp}/bin/snmpwalk",' \
      --replace-fail '"default": "/usr/bin/virsh",' '"default": "${libvirt}/bin/virsh",' \
      --replace-fail '"default": "/usr/bin/whois",' '"default": "${whois}/bin/whois",' \
      --replace-fail '"default": "/usr/lib/nagios/plugins",' '"default": "${monitoring-plugins}/bin",' \
      --replace-fail '"default": "/usr/sbin/sendmail",' '"default": "${system-sendmail}/bin/sendmail",'

    substituteInPlace $out/LibreNMS/wrapper.py --replace-fail '/usr/bin/env php' '${phpPackage}/bin/php'
    substituteInPlace $out/LibreNMS/__init__.py --replace-fail '"/usr/bin/env", "php"' '"${phpPackage}/bin/php"'
    substituteInPlace $out/snmp-scan.py --replace-fail '"/usr/bin/env", "php"' '"${phpPackage}/bin/php"'

    substituteInPlace $out/lnms --replace-fail '\App\Checks::runningUser();' '//\App\Checks::runningUser(); //removed as nix forces ownership to root'

    wrapProgram $out/daily.sh --prefix PATH : ${phpPackage}/bin

    php $out/artisan vue-i18n:generate --multi-locales --format=umd

    rm -rf $out/logs $out/rrd $out/bootstrap/cache $out/storage $out/.env
    ln -s ${logDir} $out/logs
    ln -s ${dataDir}/config.php $out/config.php
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/rrd $out/rrd
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
  '';

  passthru = {
    phpPackage = phpPackage;
    tests.librenms = nixosTests.librenms;
  };

  meta = with lib; {
    description = "Auto-discovering PHP/MySQL/SNMP based network monitoring";
    homepage = "https://www.librenms.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ netali ];
    teams = [ teams.wdz ];
    platforms = platforms.linux;
  };
}
