{ callPackage
, fetchurl
, lib
, stdenv
, pkg-config
, which
, bison
, flex
, json_c
, libevent
, libxml2
, mariadb-connector-c
, pcre
, gnugrep
, gawk
, coreutils
, gdb
, gnused
, openssl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kamailio";
  version = "5.7.4";

  src = fetchurl {
    url = "https://www.kamailio.org/pub/kamailio/${finalAttrs.version}/src/kamailio-${finalAttrs.version}_src.tar.gz";
    hash = "sha256-AP9zgGFuoM+gsVmoepfedFTwDOM3RpsRpO6gS/4AMfM=";
  };

  buildInputs = [
    json_c
    libevent
    libxml2
    mariadb-connector-c
    pcre
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
    which
    bison
    flex
  ];

  modules = [
    "db_mysql"
    "dialplan"
    "jsonrpcc"
    "json"
    "lcr"
    "presence"
    "presence_conference"
    "presence_dialoginfo"
    "presence_mwi"
    "presence_profile"
    "presence_reginfo"
    "presence_xml"
    "pua"
    "pua_bla"
    "pua_dialoginfo"
    "pua_json"
    "pua_reginfo"
    "pua_rpc"
    "pua_usrloc"
    "pua_xmpp"
    "regex"
    "rls"
    "tls"
    "xcap_client"
    "xcap_server"
  ];

  configurePhase = ''
    runHook preConfigure

    make PREFIX="$out" include_modules="${lib.concatStringsSep " " finalAttrs.modules}" cfg

    runHook postConfigure
  '';

  preInstall = ''
    makeFlagsArray+=(PREFIX="$out" "MYSQLCFG=${lib.getDev mariadb-connector-c}/bin/mariadb_config")
  '';

  postInstall = ''
    echo 'MD5="${coreutils}/bin/md5sum"' >> $out/etc/kamailio/kamctlrc
    echo 'AWK="${gawk}/bin/awk"' >> $out/etc/kamailio/kamctlrc
    echo 'GDB="${gdb}/bin/gdb"' >> $out/etc/kamailio/kamctlrc
    echo 'GREP="${gnugrep}/bin/grep "' >> $out/etc/kamailio/kamctlrc
    echo 'EGREP="${gnugrep}/bin/grep -E"' >> $out/etc/kamailio/kamctlrc
    echo 'SED="${gnused}/bin/sed"' >> $out/etc/kamailio/kamctlrc
    echo 'LAST_LINE="${coreutils}/bin/tail -n 1"' >> $out/etc/kamailio/kamctlrc
    echo 'EXPR="${gnugrep}/bin/expr"' >> $out/etc/kamailio/kamctlrc
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    kamailio-bin = callPackage ./test-kamailio-bin { };
  };

  meta = {
    description = "Fast and flexible SIP server, proxy, SBC, and load balancer";
    homepage = "https://www.kamailio.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mawis ];
    platforms = lib.platforms.linux;
  };
})
