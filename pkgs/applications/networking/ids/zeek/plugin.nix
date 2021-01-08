{ fetchFromGitHub, writeScript, postgresql, rdkafka, confdir, PostgresqlPlugin, KafkaPlugin, zeekctl, Http2Plugin }:

rec {
  install_plugin = writeScript "install_plugin" (import ./install_plugin.nix { });
  zeek-postgresql = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugins.json)).zeek-postgresql;
  metron-bro-plugin-kafka = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugins.json)).metron-bro-plugin-kafka;
  bro-http2 = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugins.json)).bro-http2;

  postFixup =  (if zeekctl then ''
         substituteInPlace $out/etc/zeekctl.cfg \
         --replace "CfgDir = $out/etc" "CfgDir = ${confdir}/etc" \
         --replace "SpoolDir = $out/spool" "SpoolDir = ${confdir}/spool" \
         --replace "LogDir = $out/logs" "LogDir = ${confdir}/logs"


         echo "scriptsdir = ${confdir}/scripts" >> $out/etc/zeekctl.cfg
         echo "helperdir = ${confdir}/scripts/helpers" >> $out/etc/zeekctl.cfg
         echo "postprocdir = ${confdir}/scripts/postprocessors" >> $out/etc/zeekctl.cfg
         echo "sitepolicypath = ${confdir}/policy" >> $out/etc/zeekctl.cfg

         ## default disable sendmail
         echo "sendmail=" >> $out/etc/zeekctl.cfg
         '' else "") +
  (if Http2Plugin then ''
       ##INSTALL ZEEK Plugins
       bash ${install_plugin} bro-http2 ${bro-http2}
         '' else "") +

  (if KafkaPlugin then ''
         ##INSTALL ZEEK Plugins
       bash ${install_plugin} metron-bro-plugin-kafka ${metron-bro-plugin-kafka}
         '' else "") +
  (if PostgresqlPlugin then ''
             bash ${install_plugin} zeek-postgresql ${zeek-postgresql}
    '' else "");
}
