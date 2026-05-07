{
  lib,
  fetchFromGitHub,
  unixtools,
  php,
  python3,
  makeWrapper,
  nixosTests,
  # run-time dependencies
  graphviz,
  ipmitool,
  libvirt,
  monitoring-plugins,
  net-snmp,
  nfdump,
  rrdtool,
  system-sendmail,
  dataDir ? "/var/lib/librenms",
  logDir ? "/var/log/librenms",
}:

let
  phpPackage = php.withExtensions ({ enabled, all }: enabled ++ [ all.memcached ]);
in
phpPackage.buildComposerProject2 rec {
  pname = "librenms";
  version = "26.3.1";

  src = fetchFromGitHub {
    owner = "librenms";
    repo = "librenms";
    tag = version;
    hash = "sha256-wLmZHE7W1ulBvUBpwVatdR8etFVhdG/zpggUpNIb65s=";
  };

  vendorHash = "sha256-uJ7DBJGQ4D1UnZXSUnrO3Fy3xEFz6ZxcMQ12E2jKKSM=";

  php = phpPackage;

  buildInputs = [
    graphviz
    ipmitool
    libvirt
    monitoring-plugins
    net-snmp
    nfdump
    rrdtool
    system-sendmail
    unixtools.whereis
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
      $out/resources/definitions/config_definitions.json \
      --replace-fail '"default": "fping",' '"default": "/run/wrappers/bin/fping",' \
      --replace-fail '"default": "fping6",' '"default": "/run/wrappers/bin/fping6",' \
      --replace-fail '"default": "rrdtool",' '"default": "${rrdtool}/bin/rrdtool",' \
      --replace-fail '"default": "snmpgetnext",' '"default": "${net-snmp}/bin/snmpgetnext",' \
      --replace-fail '"default": "traceroute",' '"default": "/run/wrappers/bin/traceroute",' \
      --replace-fail '"default": "/usr/bin/ipmitool",' '"default": "${ipmitool}/bin/ipmitool",' \
      --replace-fail '"default": "/usr/bin/nfdump",' '"default": "${nfdump}/bin/nfdump",' \
      --replace-fail '"default": "/usr/bin/snmpbulkwalk",' '"default": "${net-snmp}/bin/snmpbulkwalk",' \
      --replace-fail '"default": "/usr/bin/snmpget",' '"default": "${net-snmp}/bin/snmpget",' \
      --replace-fail '"default": "/usr/bin/snmptranslate",' '"default": "${net-snmp}/bin/snmptranslate",' \
      --replace-fail '"default": "/usr/bin/snmpwalk",' '"default": "${net-snmp}/bin/snmpwalk",' \
      --replace-fail '"default": "/usr/bin/virsh",' '"default": "${libvirt}/bin/virsh",' \
      --replace-fail '"default": "/usr/lib/nagios/plugins",' '"default": "${monitoring-plugins}/bin",' \
      --replace-fail '"default": "/usr/sbin/sendmail",' '"default": "${system-sendmail}/bin/sendmail",'

    if grep -q /usr/bin $out/resources/definitions/config_definitions.json; then
      echo "Please patch the extra /usr/bin paths found above!"
      exit 1
    fi

    substituteInPlace $out/LibreNMS/wrapper.py --replace-fail '/usr/bin/env php' '${phpPackage}/bin/php'
    substituteInPlace $out/LibreNMS/__init__.py --replace-fail '"/usr/bin/env", "php"' '"${phpPackage}/bin/php"'
    substituteInPlace $out/snmp-scan.py --replace-fail '"/usr/bin/env", "php"' '"${phpPackage}/bin/php"'

    substituteInPlace $out/app/Listeners/CommandStartingListener.php \
      --replace-fail "! function_exists('posix_getpwuid') || ! function_exists('posix_geteuid')" "true"

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

  meta = {
    description = "Auto-discovering PHP/MySQL/SNMP based network monitoring";
    homepage = "https://www.librenms.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      netali
      johannwagner
    ];
    platforms = lib.platforms.linux;
  };
}
